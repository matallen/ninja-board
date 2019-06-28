package com.redhat.sso.ninja;

import java.io.IOException;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.DELETE;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;

import com.google.common.base.Joiner;
import com.google.common.base.Splitter;
import com.google.common.collect.Lists;
import com.google.gdata.util.common.base.StringUtil;
import com.redhat.sso.ninja.Database2.TASK_FIELDS;
import com.redhat.sso.ninja.utils.Json;
import com.redhat.sso.ninja.utils.MapBuilder;

@Path("/")
public class TasksController {
  private static final Logger log=Logger.getLogger(TasksController.class);
  

  @GET
  @Path("/testTask")
  public Response testTask(@Context HttpServletRequest request,@Context HttpServletResponse response) throws JsonGenerationException, JsonMappingException, IOException, URISyntaxException{
  	
  	String task=request.getParameter("task");
  	String user=request.getParameter("user");
  	String subtasks=request.getParameter("subtasks");
  	
  	if (StringUtils.isNotBlank(task) && StringUtils.isNotBlank(user) && StringUtils.isNotBlank(subtasks)){
  		Database2 db=Database2.get();
  		String[] sTasks=subtasks.split(",");
  		db.addTask(task, user, sTasks);
  	}else{
  		return Response.status(500).entity("either 'task', 'user' or 'subtasks' query parameter was empty").build();
  	}
  	return Response.status(200).build();
  }
  
  
  @GET
  @Path("/users")
  public Response getAllPossibleUsers(@Context HttpServletRequest request, @Context HttpServletResponse response) throws JsonGenerationException, JsonMappingException, IOException, URISyntaxException{
//  	{"name":"Mat Allen", "username":"matallen", "id":"3470466"},
//  	{"name":"Andrew Block", "username":"saber1041", "id":"1191285"}
  	return Response.status(200).build();
  }
  
	@POST
	@Path("/tasks")
	public Response newTask(@Context HttpServletRequest request,@Context HttpServletResponse response) throws JsonGenerationException, JsonMappingException, IOException, URISyntaxException{
		log.info("NewTask:: [POST] /tasks");
		String data=IOUtils.toString(request.getInputStream());
		log.debug("data = "+data);
		Database2 db=Database2.get();
		
		Map<String, String> task=new HashMap<String, String>();
		mjson.Json json=mjson.Json.read(data);
		for(Entry<String, Object> e:json.asMap().entrySet()){
			task.put(e.getKey(), (String)e.getValue());
		}
		task.put("list", "todo"); // start every task on the todo list
		
		task.put(TASK_FIELDS.UID.v, UUID.randomUUID().toString());
		task.put(TASK_FIELDS.ID.v, Config.get().getNextTaskNum());
		db.getTasks().add(task);
		
		db.save();
		
		return Response.status(200).entity(task.get(TASK_FIELDS.ID.v)).build();
	}
	
	@GET
	@Path("/tasks")
	public Response getTasks(@Context HttpServletRequest request,@Context HttpServletResponse response) throws JsonGenerationException, JsonMappingException, IOException, URISyntaxException{
		log.info("GetTasks:: [GET] /tasks");
		
		Map<String, Object> result=new HashMap<String, Object>();
		
		Map<String, List<Map<String, String>>> boards=new HashMap<String, List<Map<String,String>>>();
		List<Map<String, String>> tasks=Database2.get().getTasks();
		for(Map<String, String> task:tasks){
			String list=task.get(TASK_FIELDS.LIST.v);
			log.debug("getTasks():: task key = "+list);
			log.debug("task "+task.get("id")+" list name = "+list);
			
			if (!boards.containsKey(list))
				boards.put(list, new ArrayList<Map<String,String>>());
			boards.get(list).add(task);
		}
		
		String including=request.getParameter("including");
		if (including!=null && including.toLowerCase().indexOf("users")>=0)
		  result.put("users", Config.get().getUsers());	
		
		result.put("boards", boards);
		
		return Response.ok().type(MediaType.APPLICATION_JSON).entity(Json.newObjectMapper(true).writeValueAsString(result)).build();
	}

	@POST
	@Path("/tasks/{taskId}/delete")
	public Response deleteTask(@PathParam("taskId") String taskId, @Context HttpServletRequest request,@Context HttpServletResponse response) throws JsonGenerationException, JsonMappingException, IOException, URISyntaxException{
		log.info("DeleteTask:: [POST] /tasks/"+taskId+"/delete");
		for(Map<String, String> task:Database2.get().getTasks()){
			if (taskId.equals(task.get(TASK_FIELDS.ID.v))){
				Database2.get().getTasks().remove(task);
				return Response.ok().build();
			}
		}
		return Response.serverError().build();
	}
	
	
	@POST
	@Path("/tasks/{taskId}")
	public Response updateTask(@PathParam("taskId") String taskId, @Context HttpServletRequest request,@Context HttpServletResponse response) throws JsonGenerationException, JsonMappingException, IOException, URISyntaxException{
		log.info("UpdateTask:: [GET] /tasks/"+taskId);
		
		String data=IOUtils.toString(request.getInputStream(), "UTF-8");
		log.debug("request data = "+data);
		mjson.Json json=mjson.Json.read(data);
		
		Map<String, Object> updates=json.asMap();
		String targetListId=null;
		if (updates.containsKey("list")){
			targetListId=((String)(updates.get("list"))).replaceAll("_","");
		}
		
		Database2 db=Database2.get();
		for(Map<String, String> task:db.getTasks()){
			if (taskId.equals(task.get(TASK_FIELDS.ID.v))){
				
				log.debug(taskId+":: Found - updating properties...");
				for(Entry<String, Object> e:json.asMap().entrySet()){
					if (!e.getKey().equals("list")){// so we dont process the list twice, since it isnt a property but a location where the task resides
						log.debug(taskId+":: saving key="+e.getKey()+", value="+e.getValue());
						task.put(e.getKey(), (String)e.getValue());
					}
				}
				
				if (null!=targetListId){
					log.debug(taskId+":: Adding to list: "+targetListId);
					task.put(TASK_FIELDS.LIST.v, targetListId);
				}
				
			}
		}
		
		db.save();
		
		return Response.ok().build();
	}

	
	// USER ASSIGNMENT
	@DELETE
	@Path("/tasks/{taskId}/assigned/{user}")
	public Response removeAssignee(@PathParam("taskId") String taskId, @PathParam("user") String user, @Context HttpServletRequest request,@Context HttpServletResponse response) throws JsonGenerationException, JsonMappingException, IOException, URISyntaxException{
		log.info("removeAssignee:: [DELETE] /tasks/"+taskId+"/assigned/"+user);
		Database2 db=Database2.get();
		Map<String, String> task=getTaskById(db, taskId);

		if (task.get("assigned")==null) task.put("assigned", ""); // lazy init for backwards compat
		List<String> assigned=Lists.newArrayList(Splitter.on(",").split(task.get("assigned")));

		if (assigned.contains(user))
			assigned.remove(user);
		
		task.put("assigned", Joiner.on(",").join(assigned));
		db.save();
		return Response.ok().build();
	}
	@POST
	@Path("/tasks/{taskId}/assigned/{user}")
	public Response addAssignee(@PathParam("taskId") String taskId, @PathParam("user") String user, @Context HttpServletRequest request,@Context HttpServletResponse response) throws JsonGenerationException, JsonMappingException, IOException, URISyntaxException{
		log.info("addAssignee:: [POST] /tasks/"+taskId+"/assigned/"+user);
		Database2 db=Database2.get();
		Map<String, String> task=getTaskById(db, taskId);
		
		if (task.get("assigned")==null) task.put("assigned", ""); // lazy init for backwards compat
		List<String> assigned=Lists.newArrayList(Splitter.on(",").split(task.get("assigned")));
		
		if (!assigned.contains(user))
			assigned.add(user);
		
		task.put("assigned", Joiner.on(",").skipNulls().join(assigned));
		db.save();
		return Response.ok().build();
	}
	@GET
	@Path("/tasks/{taskId}/assigned")
	public Response getAssigned(@PathParam("taskId") String taskId, @PathParam("user") String user, @Context HttpServletRequest request,@Context HttpServletResponse response) throws JsonGenerationException, JsonMappingException, IOException, URISyntaxException{
		log.info("getAssigned:: [POST] /tasks/"+taskId+"/assigned");
		
		Database2 db=Database2.get();
		Map<String, String> task=getTaskById(db, taskId);
		
		if (task.get("assigned")==null) task.put("assigned", ""); // lazy init for backwards compat
//		List<String> assigned=Arrays.asList(task.get("assigned").split(","));
		List<String> assigned=Lists.newArrayList(Splitter.on(",").split(task.get("assigned")));
		
		return Response.ok().type(MediaType.APPLICATION_JSON).entity(Json.newObjectMapper(true).writeValueAsString(assigned)).build();
	}
	
//	public static void main(String[] ad){
//		List<String> assigned=Splitter.on(",").split("");
//		System.out.println(assigned);
//	}
//	
	
	static class Splitter{
		String d;
		public Splitter(String d){
			this.d=d;
		}
		static public Splitter on(String delimiter){
			return new Splitter(delimiter);
		}
		public List<String> split(String input){
			List<String> result=new ArrayList<String>();
			Iterable<String> xx=com.google.common.base.Splitter.on(d).split(input);
			for(String x:xx){
				if (!StringUtils.isEmpty(x.trim()))
						result.add(x);
			}
			return result;
		}
	}
	
	// LABELS
	//@DELETE
	//@Path("/tasks/{taskId}/labels/{label}")
	//public Response removeLabel(@PathParam("taskId") String taskId, @PathParam("label") String label, @Context HttpServletRequest request,@Context HttpServletResponse response) throws JsonGenerationException, JsonMappingException, IOException, URISyntaxException{
	//	log.info("RemoveLabel:: [DELETE] /tasks/"+taskId+"/labels/"+label);
	//	Database2 db=Database2.get();
	//	for(Map<String, Object> task:db.getTasks()){
	//		if (taskId.equals(task.get(TASK_FIELDS.ID.v))){
	//			
	//			if (!task.containsKey(TASK_FIELDS.LABELS.v))
	//				task.put(TASK_FIELDS.LABELS.v, new ArrayList<Map<String,String>>());
	//			
	//			
	//			List<Map<String,String>> f=(List<Map<String,String>>)task.get(TASK_FIELDS.LABELS.v);
	//			
	//			for(Map<String,String> x:f){
	//				if (label.equals(x.get("label"))){
	//					f.remove(x);
	//					break;
	//				}
	//			}
	//		}
	//	}
	//	db.save();
	//	return Response.ok().build();
	//}
	//@POST
	//@Path("/tasks/{taskId}/labels/{label}")
	//public Response addLabel(@PathParam("taskId") String taskId, @PathParam("label") String label, @Context HttpServletRequest request,@Context HttpServletResponse response) throws JsonGenerationException, JsonMappingException, IOException, URISyntaxException{
	//	log.info("addLabel:: [POST] /tasks/"+taskId+"/labels/"+label);
	//	Database2 db=Database2.get();
	//	for(Map<String, Object> task:db.getTasks()){
	//		if (taskId.equals(task.get(TASK_FIELDS.ID.v))){
	//			
	//			if (!task.containsKey(TASK_FIELDS.LABELS.v))
	//				task.put(TASK_FIELDS.LABELS.v, "");
	//			
	//			List<Map<String,String>> f=(List<Map<String,String>>)task.get(TASK_FIELDS.LABELS.v);
	//			
	//			Map<String,String> newLabel=new HashMap<String, String>();
	//			newLabel.put("label", label);
	//			newLabel.put("color", "#71b568");
	//			f.add(newLabel);
	//		}
	//	}
	//	db.save();
	//	return Response.ok().build();
	//}
	

	// LABELS
	@DELETE
	@Path("/tasks/{taskId}/labels/{label}")
	public Response removeLabel(@PathParam("taskId") String taskId, @PathParam("label") String label, @Context HttpServletRequest request,@Context HttpServletResponse response) throws JsonGenerationException, JsonMappingException, IOException, URISyntaxException{
		log.info("RemoveLabel:: [DELETE] /tasks/"+taskId+"/labels/"+label);
		Database2 db=Database2.get();
		for(Map<String, String> task:db.getTasks()){
			if (taskId.equals(task.get(TASK_FIELDS.ID.v))){
				
				if (!task.containsKey(TASK_FIELDS.LABELS.v))
					task.put(TASK_FIELDS.LABELS.v, "");
				
				String f=task.get(TASK_FIELDS.LABELS.v);
				
				List<String> newList=new ArrayList<String>();
				for(String x:f.split(","))
					if (!x.startsWith(label))
						newList.add(x);
				
				task.put(TASK_FIELDS.LABELS.v, Joiner.on(",").skipNulls().join(newList));
				
			}
		}
		db.save();
		return Response.ok().build();
	}
	@POST
	@Path("/tasks/{taskId}/labels/{label}")
	public Response addLabel(@PathParam("taskId") String taskId, @PathParam("label") String label, @Context HttpServletRequest request,@Context HttpServletResponse response) throws JsonGenerationException, JsonMappingException, IOException, URISyntaxException{
		log.info("addLabel:: [POST] /tasks/"+taskId+"/labels/"+label);
		
		
		Database2 db=Database2.get();
		for(Map<String, String> task:db.getTasks()){
			if (taskId.equals(task.get(TASK_FIELDS.ID.v))){
				
				if (!task.containsKey(TASK_FIELDS.LABELS.v))
					task.put(TASK_FIELDS.LABELS.v, "");
				
				String f=task.get(TASK_FIELDS.LABELS.v);
//				List<String> split=new ArrayList<String>();
				List<String> split=Splitter.on(",").split(f);
				
//				for(String x:f.split(","))
//					split.add(x);
				split.add(label+"|#71b568");
				task.put(TASK_FIELDS.LABELS.v, Joiner.on(",").join(split));
				
			}
		}
		db.save();
		return Response.ok().build();
	}
	
	
	
	// GENERAL HELPER FUNCTIONS
	private Map<String, String> getTaskById(Database2 db, String taskId){
		for(Map<String, String> task:db.getTasks()){
			if (taskId.equals(task.get(TASK_FIELDS.ID.v))){
				return task;
			}
		}
		return null;
	}
	
}

package com.redhat.sso.ninja;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;

import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;

import com.redhat.sso.ninja.utils.Json;
import com.redhat.sso.ninja.utils.MapBuilder;
import com.redhat.sso.ninja.utils.ResponseUtils;

@Path("/")
public class UserAndScorecardController{
  private static final Logger log=Logger.getLogger(UserAndScorecardController.class);
  private static final String ENC="UTF-8";

  public static void main(String[] args) throws Exception{
  	UserAndScorecardController t=new UserAndScorecardController();
  	t.insertOrUpdateUser(Json.newObjectMapper(true).writeValueAsString(new MapBuilder<String,Object>()
  			.put("email", "test@redhat.com")
  			.put("Surname", "Bloggs")
  			.build()), "test"
  			, false);
  	System.out.println(t.getUser("test").getEntity());
  }
  
  @GET
  @Path("/users/{user}")
  public Response getUser(@PathParam("user") String user) throws JsonGenerationException, JsonMappingException, IOException{
  	log.debug("Request made for user ["+user+"]");
    Database2 db=Database2.get();
    Map<String, String> userInfo=db.getUsers().get(user);
    log.debug(user+" user data for userInfo "+(userInfo!=null?"found":"NOT FOUND!"));
    
    String payload="{\"status\":\"ERROR\",\"message\":\"Unable to find user: "+user+"\", \"displayName\":\"You ("+user+") are not registered\"}";
    if (userInfo!=null){
    	payload=Json.newObjectMapper(true).writeValueAsString(new MapBuilder<String, Object>()
        	.put("userId", user)
        	.putAll(userInfo)
        	.build());
    }
    
    return ResponseUtils.newResponse(payload.contains("ERROR")?500:200).entity(payload).build();
  }
  @PUT
  @Path("/users/{user}")
  public Response updateUser(@Context HttpServletRequest request, @PathParam("user") String user) throws JsonGenerationException, JsonMappingException, IOException{
  	return insertOrUpdateUser(IOUtils.toString(request.getInputStream(), ENC), user, false);
  }
  @POST
  @Path("/users/{user}")
  public Response newUser(@Context HttpServletRequest request, @PathParam("user") String user) throws JsonGenerationException, JsonMappingException, IOException{
  	return insertOrUpdateUser(IOUtils.toString(request.getInputStream(), ENC), user, true);
  }
  @DELETE
  @Path("/users/{user}")
  public Response deleteUser(@PathParam("user") String user) throws JsonGenerationException, JsonMappingException, IOException{
  	log.debug("Deleting User: "+user);
  	Database2 db=Database2.get();
  	if (db.getUsers().containsKey(user)){
  		db.getUsers().remove(user);
  		db.getScoreCards().remove(user);
  		db.save();
  		return ResponseUtils.newResponse(200).build();
  	}
  	return ResponseUtils.newResponse(500).build();
  }
  
  
  
  
  
  @POST
  @Path("/scorecards/{user}")
  public Response newScorecard(@Context HttpServletRequest request ,@PathParam("user") String user) throws JsonGenerationException, JsonMappingException, IOException{
  	return insertOrUpdateScorecard(IOUtils.toString(request.getInputStream(), ENC), user, true);
  }
  
  
  @PUT
  @Path("/scorecards/{user}")
  public Response updateScoreCard(@Context HttpServletRequest request ,@PathParam("user") String user) throws JsonGenerationException, JsonMappingException, IOException{
  	return insertOrUpdateScorecard(IOUtils.toString(request.getInputStream(), ENC), user, false);
  }
  
  
  private Response insertOrUpdateUser(String payload, String username, boolean isNew) throws JsonGenerationException, JsonMappingException, IOException{
  	log.debug("Saving User: "+ payload);
  	Database2 db=Database2.get();
  	Map<String, Object> map=new ObjectMapper().readValue(payload, new TypeReference<HashMap<String,Object>>(){});
		Map<String, String>  userInfo=db.getUsers().containsKey(username)?db.getUsers().get(username):new HashMap<>();
		for(String k:map.keySet()){
			log.debug("Setting 'userInfo."+k+"' to "+(String)map.get(k));
			userInfo.put(k, (String)map.get(k));
		}
		db.getUsers().put(username, userInfo);
		db.save();
		return ResponseUtils.newResponse(200).build();
  }
  
  private Response insertOrUpdateScorecard(String payload, String username, boolean isNew) throws JsonGenerationException, JsonMappingException, IOException{
		log.debug("Saving Scorecard: "+payload);
		Database2 db=Database2.get();
		Map<String, Object> map=new ObjectMapper().readValue(payload, new TypeReference<HashMap<String, Object>>(){});
		Map<String, Integer> scorecard=db.getScoreCards().containsKey(username)?db.getScoreCards().get(username):new HashMap<>();
		for (String k:map.keySet()){
			log.debug("Setting 'scorecard."+k+"' to "+(String)map.get(k));
			scorecard.put(k, Integer.parseInt((String)map.get(k)));
		}
		db.getScoreCards().put(username, scorecard);

		db.save();
		return ResponseUtils.newResponse(200).build();
  	
  	
  }
  
}

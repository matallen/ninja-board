package com.redhat.sso.ninja;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.UUID;

import org.apache.log4j.Logger;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.annotate.JsonIgnore;
import org.codehaus.jackson.map.JsonMappingException;

import com.google.common.base.Joiner;
import com.redhat.sso.ninja.utils.IOUtils2;
import com.redhat.sso.ninja.utils.Json;

public class Database2{
  private static final Logger log=Logger.getLogger(Database2.class);
  public static final String STORAGE="target/ninja-persistence/database2.json";
  public static final File STORAGE_AS_FILE=new File(STORAGE);
  public static Integer MAX_EVENT_ENTRIES=1000;
  public static boolean systemUpdating=false;
  
  // User -> Pool (sub pool separated with a dot) + Score
  private Map<String, Map<String, Integer>> scorecards;
  private Map<String, Map<String, String>> users;
  private List<Map<String, String>> events;
  private List<Map<String, String>> tasks;
  
  // PoolId -> UserId + Score
  private String created;
  private String version;
  static SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
  static SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
  
  public Database2(){
    created=sdf.format(new Date());
  }
  public String getCreated(){ return created; }
  public String getVersion(){ return version; }
  public void setVersion(String version){
  	this.version=version;
  }
  
  
  public Database2 increment(String poolId, String userId, Integer increment, Map<String, String> params){
    if (null==poolId || null==userId){
      log.error("Unable to add due to null key [poolId="+poolId+", userId="+userId+"]");
      return this;
    }
    if (users.containsKey(userId)){ // means the user is registered
      if (null==scorecards.get(userId)) scorecards.put(userId, new HashMap<String, Integer>());
      if (null==scorecards.get(userId).get(poolId)) scorecards.get(userId).put(poolId, 0);
      log.info("Incrementing points: user="+userId+", poolId="+poolId+", increment/points="+increment+" + params="+params);
      scorecards.get(userId).put(poolId, scorecards.get(userId).get(poolId)+increment);
      
    	if (params!=null && params.get("id")!=null && params.get("id").startsWith("TR") && null!=params.get("linkId")){ // its a trello point
    		addEvent("Points Increment", userId, increment+" point"+(increment<=1?"":"s")+" added to "+poolId+ " ([Trello card: "+params.get("linkId")+"|"+params.get("linkId")+"])");
    	}else{ // it's a point from any other source
    		addEvent("Points Increment", userId, increment+" point"+(increment<=1?"":"s")+" added to "+poolId);
    	}
      
      
    }else{
      log.debug("Unregistered user detected ["+userId+"]");
    }
    
    return this;
  }
  
  public Map<String, Map<String, String>> getUsers(){
    if(null==users) users=new HashMap<String, Map<String, String>>();
    return users;
  }
  public Map<String, Map<String, Integer>> getScoreCards(){
    if (null==scorecards) scorecards=new HashMap<String, Map<String,Integer>>();
    return scorecards;
  }
  
  public List<Map<String, String>> getEvents(){
    if (null==events) events=new ArrayList<Map<String,String>>();
    return events;
  }
  public enum EVENT_FIELDS{
  	TIMESTAMP("timestamp"),
  	TYPE("type"),
  	USER("user"),
  	TEXT("text");
  	public String v;
  	EVENT_FIELDS(String v){
  		this.v=v;
  	}
  }
  
  public List<Map<String, String>> getTasks(){
    if (null==tasks) tasks=new ArrayList<Map<String, String>>();
    return tasks;
  }
  public enum TASK_FIELDS{
  	TIMESTAMP("timestamp"),
  	USER("user"),
  	
  	LIST("list"),
  	ID("id"),
  	UID("uid"),
  	TITLE("title"),
  	OWNERS("owners"),
  	LABELS("labels"),
  	SUBTASKS("subtasks");
  	public String v;
  	TASK_FIELDS(String v){
  		this.v=v;
  	}
  }
  
  public void addEvent(String type, String user, String text){
    Map<String,String> event=new HashMap<String, String>();
    event.put(EVENT_FIELDS.TIMESTAMP.v, sdf2.format(new Date()));
    event.put(EVENT_FIELDS.TYPE.v, type);
    event.put(EVENT_FIELDS.USER.v, user);
    event.put(EVENT_FIELDS.TEXT.v, text);
    getEvents().add(event);
    
    // limit the events to 100 entries
    while (getEvents().size()>MAX_EVENT_ENTRIES){
      getEvents().remove(0);
    }
  }
  // user is the target user: ie. fbloggs
	public void addTask(String taskText, String user, String[] subtasks){
    Map<String,String> task=new HashMap<String, String>();
    task.put(TASK_FIELDS.TIMESTAMP.v, sdf2.format(new Date()));
    task.put(TASK_FIELDS.UID.v, UUID.randomUUID().toString());
    task.put(TASK_FIELDS.ID.v, Config.get().getNextTaskNum());
    task.put(TASK_FIELDS.TITLE.v, taskText);
    task.put(TASK_FIELDS.USER.v, user);
    task.put(TASK_FIELDS.LIST.v, "todo");
    task.put(TASK_FIELDS.SUBTASKS.v, Joiner.on(",").join(subtasks));
    getTasks().add(task);
	}
  
  private Set<String> pointsDuplicateChecker=new HashSet<String>();
  public Set<String> getPointsDuplicateChecker(){
    if (null==pointsDuplicateChecker) pointsDuplicateChecker=new HashSet<String>();
    return pointsDuplicateChecker;
  }
  
  @JsonIgnore
  private Map<String, Map<String, Integer>> leaderboard=new HashMap<String, Map<String, Integer>>();
  public Map<String, Map<String, Integer>> getLeaderboard(){
//    leaderboard.putAll(users);
    for(Entry<String, Map<String, String>> e:users.entrySet()){
      leaderboard.put(e.getKey(), new HashMap<String, Integer>());
    }
    
    for(Entry<String, Map<String, Integer>> e:scorecards.entrySet()){
//      leaderboard.get(e.getKey()).setScorecard(e.getValue());
      leaderboard.get(e.getKey()).putAll(e.getValue());
    }
    return leaderboard;
  }
  
  public synchronized void save(){
    try{
      long s=System.currentTimeMillis();
      if (!new File(STORAGE).getParentFile().exists())
        new File(STORAGE).getParentFile().mkdirs();
      IOUtils2.writeAndClose(Json.newObjectMapper(true).writeValueAsBytes(this), new FileOutputStream(new File(STORAGE)));
      log.info("Database saved ("+(System.currentTimeMillis()-s)+"ms, size="+new File(STORAGE).length()+")");
    }catch (JsonGenerationException e){
      e.printStackTrace();
    }catch (JsonMappingException e){
      e.printStackTrace();
    }catch (FileNotFoundException e){
      e.printStackTrace();
    }catch (IOException e){
      e.printStackTrace();
    }
  }
  
  public static synchronized Database2 load(){
    try{
//      Database db=new Database();
//      Database db=Json.newObjectMapper(true).readValue(IOUtils2.toStringAndClose(new FileInputStream(new File(storage))), new TypeReference<HashMap<String,Map<String,Integer>>>(){});
    	log.info("Database loading (size="+new File(STORAGE).length()+")");
      Database2 db=Json.newObjectMapper(true).readValue(IOUtils2.toStringAndClose(new FileInputStream(new File(STORAGE))), Database2.class);
      return db;
    }catch (JsonParseException e){
      e.printStackTrace();
    }catch (JsonMappingException e){
      e.printStackTrace();
    }catch (FileNotFoundException e){
      e.printStackTrace();
    }catch (IOException e){
      e.printStackTrace();
    }
    return null;
  }
  
  private static Database2 instance=null;
//  public static Database2 getCached(){
//    if (null==instance){
//      instance=Database2.get();
//    }
//    return instance;
//  }
  public static Database2 get(){
    if (!new File(STORAGE).exists()){
    	log.warn("No database file found, creating new/blank/default one...");
    	new Database2().save();
    }
    if (null==instance){
      instance=Database2.load();
      log.info("Loading/Replaced 'instance' of database in memory");
    }
//    instance=Database2.load();
    return instance;
  }
  public static void resetInstance(){
  	instance=null;
  }
  
  public static void main(String[] asd){
    Database2.get().increment("pool", "test", 1, null);
  }


}

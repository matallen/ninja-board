package com.redhat.sso.ninja;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.nio.file.attribute.PosixFilePermission;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;

import com.redhat.sso.ninja.ChatNotification.ChatEvent;
import com.redhat.sso.ninja.utils.DownloadFile;
import com.redhat.sso.ninja.utils.FluentCalendar;
import com.redhat.sso.ninja.utils.MapBuilder;
import com.redhat.sso.ninja.utils.ParamParser;
import com.redhat.sso.ninja.utils.RegExHelper;

public class ScriptExecutor{
	private static final Logger log = Logger.getLogger(ScriptExecutor.class);
	private Database2 db;
	private File exeutionFolder;
	private Map<String,String> poolToUserIdMapper;
	
//	public abstract void allocatePoints(Database2 db, InputStream is, Map<String,Object> script, File scriptFolder, Map<String, String> poolToUserIdMapper) throws NumberFormatException, UnsupportedEncodingException, IOException;
	
	public ScriptExecutor(Database2 db, File exeutionFolder, Map<String,String> poolToUserIdMapper){
		this.db=db;
		this.exeutionFolder=exeutionFolder;
		this.poolToUserIdMapper=poolToUserIdMapper;
	}
	
	
	public static void main(String[] args) throws ParseException{
  	
		Database2 db=Database2.get(new File("target/persistence/database2.json"));
		
		Map<String,String> poolToUserIdMapper=new MapBuilder<String,String>().build();
		boolean scriptFailure=false;
		
		
		Map<String,Object> script=new MapBuilder<String,Object>()
				.put("name", "Github.SAP.Github")
//				.put("source", "https://raw.githubusercontent.com/redhat-cop/ninja-points/v1.8/github-stats.py -s ${LAST_RUN:yyyy-MM-dd} -o redhat-sap -m '^sap\\\\-(s4hana-deployment|rhsm|hostagent|hana-control|netweaver-control|hana-deployment|hana-hsr|monitoring)$'")
//				.put("source", "https://raw.githubusercontent.com/redhat-cop/ninja-points/v1.8/github-stats.py -s ${LAST_RUN:yyyy-MM-dd} -o redhat-sap")
//				.put("source", "https://raw.githubusercontent.com/redhat-cop/ninja-points/v1.8/github-stats.py -s 2020-03-01 -o redhat-sap -m \\\"^sap.(s4hana-deployment|rhsm|hostagent|hana-control|netweaver-control|hana-deployment|hana-hsr|monitoring)$\\\"")
//				.put("source", "https://raw.githubusercontent.com/redhat-cop/ninja-points/v1.8/github-stats.py -s ${LAST_RUN:yyyy-MM-dd} -o redhat-sap -m 'sap\\\\-(s4hana-deployment|rhsm|hostagent|hana-control|netweaver-control|hana-deployment|hana-hsr|monitoring)'")
//				.put("source", "https://raw.githubusercontent.com/redhat-cop/ninja-points/v1.8/github-stats.py -s ${LAST_RUN:yyyy-MM-dd} -o redhat-sap -m 'sap\\-(s4hana-deployment|rhsm|hostagent|hana-control|netweaver-control|hana-deployment|hana-hsr|monitoring)'")
				.put("source", "https://raw.githubusercontent.com/redhat-cop/ninja-points/v1.8/github-stats.py -s ${LAST_RUN:yyyy-MM-dd} -o redhat-sap -m sap-(s4hana-deployment|rhsm|hostagent|hana-control|netweaver-control|hana-deployment|hana-hsr|monitoring)")
				
				
				.put("type", "python")
		.build();
		
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
		Date lastRun2=sdf.parse("2019-03-01T00:00:00");
		
		try{
  		scriptFailure=!new ScriptExecutor(db, new File("/home/mallen/temp/ninja-script-test"), poolToUserIdMapper){
				@Override
				public void allocatePoints(Database2 db, InputStream is, Map<String, Object> script, File scriptFolder, Map<String, String> poolToUserIdMapper) throws NumberFormatException, UnsupportedEncodingException, IOException{
					System.out.println("allocating points");
					allocatePoints(db, is, script, scriptFolder, poolToUserIdMapper);;
				}
			}.run(script, lastRun2);
  	}catch(Exception e){}
	}
	
	
	
	/**
	 * 
	 * @param lastRun2 
	 * @return false for a script failure
	 */
	public boolean run(Map<String,Object> script, Date lastRun2){
    boolean scriptFailure=false;
    long start=System.currentTimeMillis();
		try{

			String command=(String)script.get("source");
			String version=RegExHelper.extract(command, "/(v.+)/");
			// enhancement: if version is null, split by / and take the penultimate item as version - this will support "master", or non v??? versions
			String name=(String)script.get("name");
			File scriptFolder=new File(exeutionFolder, name + "/" + version);
			scriptFolder.mkdirs(); // ensure the parent folders exist if they dont already

			String originalCommand=command.toString();
			command=new DownloadFile().get(command, scriptFolder, 
					PosixFilePermission.OWNER_READ, 
					PosixFilePermission.OWNER_WRITE, 
					PosixFilePermission.OWNER_EXECUTE,
					PosixFilePermission.GROUP_READ, 
					PosixFilePermission.GROUP_WRITE, 
					PosixFilePermission.GROUP_EXECUTE);

			if (command.contains("${LAST_RUN") || command.contains("${DAYS_FROM_LAST_RUN")){
				Date lastRun=FluentCalendar.get(lastRun2).add(Calendar.DAY_OF_MONTH, -1).build().getTime();
				command=convertLastRun(command, lastRun);
			}

			log.info("Script downloaded (" + version + "): " + originalCommand);
			log.info("Script executing: " + command);

			Process script_exec=Runtime.getRuntime().exec(command);
			script_exec.waitFor();
			if (script_exec.exitValue() != 0){

				BufferedReader stdInput=new BufferedReader(new InputStreamReader(script_exec.getInputStream()));
				StringBuffer sb=new StringBuffer();
				String s;
				while ((s=stdInput.readLine()) != null)
					sb.append(s).append("\n");
				log.error("Error while executing script (stdout): " + sb.toString());

				BufferedReader stdErr=new BufferedReader(new InputStreamReader(script_exec.getErrorStream()));
				sb.setLength(0);
				while ((s=stdErr.readLine()) != null)
					sb.append(s).append("\n");
				log.error("Error while executing script (stderr): " + sb.toString());

				db.addEvent("Script Execution FAILED", "", command + "\nERROR (stderr):\n" + sb.toString());

				new ChatNotification().send(ChatEvent.onScriptError, name + " script failure occurred. Please investigate");

				scriptFailure=true;

			}else{
				allocatePoints(db, script_exec.getInputStream(), script, scriptFolder, poolToUserIdMapper);
				db.addEvent("Script Execution Succeeded", "", command + " (took " + (System.currentTimeMillis() - start) + "ms)");

			}

		}catch (IOException e){
			e.printStackTrace();
		}catch (InterruptedException e){
			e.printStackTrace();
		}catch (ParseException e){
			e.printStackTrace();
		}
    
    return scriptFailure;
	}
	
	
	
  public static String convertLastRun(String command, Date lastRunDate) throws ParseException {
    Matcher m=Pattern.compile("(\\$\\{([^}]+)\\})").matcher(command);
    StringBuffer sb=new StringBuffer();
    while (m.find()){
      String toReplace=m.group(2);
      if (toReplace.contains("LAST_RUN:")){
        SimpleDateFormat sdf=new SimpleDateFormat(toReplace.split(":")[1].replaceAll("}", "")); // nasty replaceall when I just want to trim the last char
        m.appendReplacement(sb, sdf.format(lastRunDate));
        
      }else if (toReplace.contains("DAYS_FROM_LAST_RUN")){
        Date runTo2=java.sql.Date.valueOf(LocalDate.now());
        Integer daysFromLastRun=(int)((runTo2.getTime() - lastRunDate.getTime()) / (1000 * 60 * 60 * 24))+1;
        m.appendReplacement(sb, String.valueOf(daysFromLastRun));
      }else{
        // is it a system property?
        if (null!=System.getProperty(toReplace)){
          m.appendReplacement(sb, System.getProperty(toReplace));
        }else{
          m.appendReplacement(sb, "?????");
        }
      }
    }
    m.appendTail(sb);
    return sb.toString();
  }
  
  
  public void allocatePoints(Database2 db, InputStream is, Map<String,Object> script, File scriptFolder, Map<String, String> poolToUserIdMapper) throws NumberFormatException, UnsupportedEncodingException, IOException{
  	BufferedReader stdInput=new BufferedReader(new InputStreamReader(is));
  	Pattern paramsPattern=Pattern.compile(".*(\\[.*\\]).*");
  	
  	StringBuffer scriptLog=new StringBuffer();
  	String s;
  	while ((s=stdInput.readLine()) != null){
  		s=s.trim();
  		scriptLog.append(s).append("\n");
  		log.debug(s);
  		System.out.println(s);
  		
  		Map<String, String> params=new HashMap<String, String>();
  		// check for params here, extract them if present for use later on
  		if (s.matches(".* \\[.*\\]")){
  			Matcher m=paramsPattern.matcher(s);
  			if (m.find()){
  				String paramsExtract=m.group(1);
  				params.putAll(new ParamParser().splitParams(paramsExtract.replaceAll("\\[", "").replaceAll("\\]", "").trim()));
  				s=s.replaceAll("\\[.*\\]", "").trim();
  			}
  		}
  		
  		if (s.startsWith("#")){ // Informational lines only, some may need to be added to event logging as reasons points were not awarded
  			
  			
  			
  		}else if (s.contains("/")){ // ignore the line if it doesn't contain a slash
  			String[] split=s.split("/");
  			
  			// take the last section of the script name as the pool id. so "trello" stays as "trello", but "trello.thoughtleadership" becomes "thoughtleadership" where the "trello" part is the source type/context
  			String pool=(String)script.get("name");
  			String[] splitPool=pool.split("\\.");
  			pool=splitPool[splitPool.length-1];
  			
  			String actionId;
  			String poolUserId;
  			Integer inc;
  			
  			if (split.length==4){   //pool.sub
  				pool=pool+"."+split[0];
  				actionId=split[1];
  				poolUserId=split[2];
					inc=Integer.valueOf(split[3]);
					
					params.put("id", actionId);
					params.put("pool", pool);
  				
  				if (!db.getPointsDuplicateChecker().contains(actionId+"."+poolUserId)){
  					db.getPointsDuplicateChecker().add(actionId+"."+poolUserId);
  					
  					String userId=poolToUserIdMapper.get(poolUserId);
  					
  					if (null!=userId){
  						//                    System.out.println(poolUserId+" mapped to "+userId);
//  						log.info("Incrementing registered user "+poolUserId+" by "+inc);
  						db.increment(pool, userId, inc, params);//.save();
  					}else{
  						log.info("Unable to find '"+poolUserId+"' "+script.get("name")+" user - not registered? "+Database2.buildLink(params));
  						db.addEvent("Lost Points", poolUserId +"("+script.get("name")+")", script.get("name")+" user '"+poolUserId+"' was not found - not registered? "+Database2.buildLink(params));
  					}
  				}else{
  					// it's a duplicate increment for that actionId & user, so ignore it
  					log.warn(actionId+"."+poolUserId+" is a duplicate");
  				}
  				
  			}else{
  				// dont increment because we dont know the structure of the script data
  			}
  			
  			
  		}
  	}
  	
  	scriptFolder.mkdirs();
  	IOUtils.write(scriptLog.toString(), new FileOutputStream(new File(scriptFolder, "last.log")));
  	
  }
  
  
}

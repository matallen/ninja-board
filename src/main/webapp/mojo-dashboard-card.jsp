<center>
<div style="width:100%; background-color:#000">
 <div style="color:#fff; font-size:30px; font-weight:bold;">COMMUNITIES OF PRACTICE</div>
 <div style="color:#fff; font-size:30px; font-weight:bold;">YOUR GIVEBACK NINJA PROGRAM DASHBOARD</div>
</div>
<div style="width:100%; background-color:#f2f1f1;">
 <div style="color:#444; font-size:10pt;">Hover over the chart to see your progress and/or what is needed to reach the next belt level.</div>
</div>
<br/>
<div style="height:500px;">
	
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
		<!--
		<script src="https://github.com/chartjs/Chart.js/releases/download/v2.6.0/Chart.min.js"></script>
		-->
		
		<script src="https://www.chartjs.org/dist/2.7.2/Chart.bundle.js"></script>
		
	

		<script>
			var ctx="https://ninja-graphs-ninja-graphs.6923.rh-us-east-1.openshiftapps.com/ninja-graphs/api/proxy";
			if (window.location.href.includes("localhost"))
				ctx="http://localhost:8082/community-ninja-board/api/scorecard";
			//var ctx = "http://localhost:8082/community-ninja-board/api/scorecard";
			//var ctx = "${pageContext.request.contextPath}";
		</script>
		
		
		<!--######-->
		<!-- CARD -->
		<!--######-->
		<style>
		body{
			font-family: Overpass, Arial, sans-serif;
			background-color: #f2f1f1;
		}
		.card2{
			border:1px solid #BBB;
			width: 100%;
			border-radius: 12px;
			padding: 10px;
			
			/*v3*/
			background: white;
			font-family: Overpass, Arial, sans-serif;
			font-size: 14pt;
			color: #333;
			
			/*v2
			background: rgb(0,65,83);
			font-family: Arial;
			font-size: 14pt;
			color: #eee;
			*/
			
			/*v1
			background: rgb(163,219,232);
			*/
			
			/*
			position: relative;
			top: 45px;
			*/
		}
		.cardName{
			vertical-align: top;
			font-weight: bold;
			font-size: 28pt;
			/*
			color: #eee;
			*/
		}
		.cardScore{
			vertical-align: top;
			text-align: center;
			font-weight: bold;
			font-size: 34pt;
			/*
			color: #eee;
			*/
		}
		.cardRow{
			width:100px;
		}
		.cardScoreText{
			vertical-align: top;
			text-align: center;
			font-size:9pt;
		}
		.icon{
			height: 25px;
		}
		.ninjaIcon{
			clip: rect(0px,50px,25px,0px);
			height: 80px;
		}
		.graph-label{
			font-size: 22pt;
			/*
			font-family: Arial;
			color: #eee;
			*/
			font-weight: bold;
			position:relative;
			top:20px;
		}
		
		a{
		  color: white;
		  text-decoration: none;
		}
		a:hover{
		  text-decoration: underline;
		}
		</style>
					<span id="userSelect"></span>
					<table id="dashboard" border=0 style="width:1000px;">
						<tr>
							<td colspan="2">
								<table class="card2" border=0>
									<tr>
										<td colspan="8"><span class="cardName" id="_error"></span><br/><span id="_error2"></td>
									</tr>
									<tr>
										<td class="cardName" colspan="2"><span class="_displayName"></span></td>
										<td class="cardScore" rowspan="5"><img class="ninjaIcon _level"></img></td>
										<td class="cardScore"><span class="_Trello">0</span></td>
										<td class="cardScore"><span class="_Github">0</span></td>
										<td class="cardScore"><span class="_Gitlab">0</span></td>
										<td class="cardScore"><span class="_ThoughtLeadership">0</span></td>
										<td class="cardScore"><span class="_ServicesSupport">0</span></td>
										<!--td class="cardScore"></td--> <!--chat-->
									</tr>
									<tr>
										<td class="cardRow">
											<img class="icon" src="https://www.redhat.com/profiles/rh/themes/redhatdotcom/img/logo.png">
										</td>
										<td><span class="_userId"></span></td>
										<td class="cardScoreText" style="width:110px;" rowspan="4">Trello</td>
										<td class="cardScoreText" style="width:110px;" rowspan="4">Github</td>
										<td class="cardScoreText" style="width:110px;" rowspan="4">Gitlab</td>
										<td class="cardScoreText" style="width:110px;" rowspan="4">Thought Leadership</td>
										<td class="cardScoreText" style="width:110px;" rowspan="4">Services Support Initatives</td>
										<!--td class="cardScoreText" rowspan="4"></td--> <!--chat-->
									</tr>
									<tr>
										<td class="cardRow"><img class="icon" src="https://d2k1ftgv7pobq7.cloudfront.net/meta/u/res/images/brand-assets/Logos/0099ec3754bf473d2bbf317204ab6fea/trello-logo-blue.png"></td>
										<td><span class="_trelloId"></span></td>
									</tr>
									<tr>
										<td class="cardRow"><img  style="height:20px;" src="https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png"></td>
										<td><span class="_githubId"></span></td>
									</tr>
									<tr>
										<td class="cardRow">
										<svg height="20" viewBox="0 0 1231 342" xmlns="http://www.w3.org/2000/svg" class="nav-logo"> <g fill="none" fill-rule="evenodd"> <g fill="#8C929D" class="wordmark"> <path d="M764.367 94.13h-20.803l.066 154.74h84.155v-19.136h-63.352l-.066-135.603zM907.917 221.7c-5.2 5.434-13.946 10.87-25.766 10.87-15.838 0-22.22-7.797-22.22-17.957 0-15.354 10.637-22.678 33.332-22.678 4.255 0 11.11.472 14.655 1.18v28.586zm-21.51-93.787c-16.8 0-32.208 5.952-44.23 15.858l7.352 12.73c8.51-4.962 18.91-9.924 33.802-9.924 17.02 0 24.585 8.742 24.585 23.39v7.56c-3.31-.71-10.164-1.184-14.42-1.184-36.404 0-54.842 12.757-54.842 39.454 0 23.86 14.656 35.908 36.876 35.908 14.97 0 29.314-6.852 34.278-17.954l3.782 15.118h14.657v-79.14c0-25.04-10.874-41.815-41.84-41.815zM995.368 233.277c-7.802 0-14.657-.945-19.858-3.308v-71.58c7.093-5.908 15.84-10.16 26.95-10.16 20.092 0 27.893 14.174 27.893 37.09 0 32.6-12.53 47.957-34.985 47.957m8.742-105.364c-18.592 0-28.6 12.64-28.6 12.64V120.59l-.066-26.458H955.116l.066 150.957c10.164 4.25 24.11 6.613 39.24 6.613 38.768 0 57.442-24.804 57.442-67.564 0-33.783-17.26-56.227-47.754-56.227M538.238 110.904c18.438 0 30.258 6.142 38.06 12.285l8.938-15.477c-12.184-10.678-28.573-16.417-46.053-16.417-44.204 0-75.17 26.932-75.17 81.267 0 56.935 33.407 79.14 71.624 79.14 19.148 0 35.46-4.488 46.096-8.976l-.435-60.832V162.76h-56.734v19.135h36.167l.437 46.184c-4.727 2.362-13 4.252-24.11 4.252-30.73 0-51.297-19.32-51.297-60.006 0-41.34 21.275-61.422 52.478-61.422M684.534 94.13h-20.33l.066 25.988v89.771c0 25.04 10.874 41.814 41.84 41.814 4.28 0 8.465-.39 12.53-1.126v-18.245c-2.943.45-6.083.707-9.455.707-17.02 0-24.585-8.74-24.585-23.387v-61.895h34.04v-17.01H684.6l-.066-36.617zM612.62 248.87h20.33V130.747h-20.33v118.12zM612.62 114.448h20.33V94.13h-20.33v20.318z"></path> </g> <path d="M185.398 341.13l68.013-209.322H117.39L185.4 341.13z" fill="#E24329" class="logo-svg-shape logo-dark-orange-shape"></path> <path d="M185.398 341.13l-68.013-209.322h-95.32L185.4 341.128z" fill="#FC6D26" class="logo-svg-shape logo-orange-shape"></path> <path d="M22.066 131.808l-20.67 63.61c-1.884 5.803.18 12.16 5.117 15.744L185.398 341.13 22.066 131.807z" fill="#FCA326" class="logo-svg-shape logo-light-orange-shape"></path> <path d="M22.066 131.808h95.32L76.42 5.735c-2.107-6.487-11.284-6.487-13.39 0L22.065 131.808z" fill="#E24329" class="logo-svg-shape logo-dark-orange-shape"></path> <path d="M185.398 341.13l68.013-209.322h95.32L185.4 341.128z" fill="#FC6D26" class="logo-svg-shape logo-orange-shape"></path> <path d="M348.73 131.808l20.67 63.61c1.884 5.803-.18 12.16-5.117 15.744L185.398 341.13 348.73 131.807z" fill="#FCA326" class="logo-svg-shape logo-light-orange-shape"></path> <path d="M348.73 131.808h-95.32L294.376 5.735c2.108-6.487 11.285-6.487 13.392 0l40.963 126.073z" fill="#E24329" class="logo-svg-shape logo-dark-orange-shape"></path> </g> </svg></td>
										<td><span class="_userId"></span></td>
									</tr>
									
									<tr>
										<td colspan="8" style="height: 20px;"><hr/><!-- SPACER ONLY --></td>
									</tr>
									
									<tr>
										<td colspan="8">
											
											<table border=0 style="width:100%;height:400px">
												<tr>
													<td style="width:50%;">
														<!-- #################### -->
														<!-- BOTTOM LEFT DOUGHNUT -->
														<!-- #################### -->
														<script>
															function leaderboardRefresh(){ return refreshGraph0('points', 'Doughnut', colors); }
														</script>
														<div id="leaderboard_container" class="graph" >
															<canvas id="points"></canvas>
															<center><span class="graph-label">Next Level</span></center>
														</div>
													</td>
													
													<td>
														<!-- ##################### -->
														<!-- BOTTOM RIGHT DOUGHNUT -->
														<!-- ##################### -->
														<script>
															function breakdownRefresh(){ return refreshGraph0('breakdown', 'Doughnut', colorsReverse); }
														</script>
														<div id="breakdown_container" class="graph" >
															<canvas id="breakdown"></canvas>
															<center><span class="graph-label">Points Breakdown</span></center>
												    </div>
													</td>
												</tr>
											</table>
										</td>
									</tr>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					&nbsp;<br/>
					&nbsp;<br/>

<script>
Utils = {
		getParameterByName: function(name, url) {
			if (!url) url = window.location.href;
			name = name.replace(/[\[\]]/g, "\\$&");
			var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
			    results = regex.exec(url);
			if (!results) return undefined;
			if (!results[2]) return '';
			return decodeURIComponent(results[2].replace(/\+/g, " "));
		}
}

function getUsername(){
	  var username;
	  if (Utils.getParameterByName("username")!=undefined) username=Utils.getParameterByName("username");
	  if (username==undefined && undefined!=window.parent._jive_current_user)
		  username=window.parent._jive_current_user.username;
	  if (username==undefined && undefined!=window._jive_current_user)
		  username=window._jive_current_user.username;
	  
	  if(username==undefined && window.location.href.includes("localhost")) username="mallen";
	  return username;
}

setTimeout(function(){ displ(); }, 200);

function displ(){
	username=getUsername();
	if (username==undefined){
	  setTimeout(function(){ displ(); }, 200);
	  return;
  }
	_displ(username);
}

var resets=[];
function _displ(username){
  
	for(k in resets){
		//var es=document.getElementsByClassName(k);
		//for(e in es){
	    $("."+k).each(function(index) {
	    	$(this).text(resets[k]);
	    });
		//}
	}
		
  graphs={
	  "points":         "/next"+(ctx.includes("localhost")?"l":"L")+"evel"+(ctx.includes("localhost")?"/":"_")+username,
	  "breakdown":      "/breakdown"+(ctx.includes("localhost")?"/":"_")+username,
	};
  refresh();

	var xhr = new XMLHttpRequest();
	xhr.open("GET", ctx+"/summary"+(ctx.includes("localhost")?"/":"_")+username, true);
	xhr.send();
	xhr.onloadend = function () {
	  console.log("statusCode="+xhr.status);
	  
		var json=JSON.parse(xhr.responseText);
	  if (xhr.status==500){
	    // json['displayName'] is not just a username in the event of a 500 error. its a message. need to change this at some point
	  	$("#_error").html(json['displayName']+". Please click <a style='color:white;' target='_new' href='https://mojo.redhat.com/external-link.jspa?url=https%3A%2F%2Fdocs.google.com%2Fforms%2Fd%2Fe%2F1FAIpQLSdWGcCks2zKKnVoZFQz3CieLQDc1lsSex_Knwh_-eyRm0ZQTg%2Fviewform'>here</a> to register");
	  	$("#_error2").html("Please note registration takes approx. 24 hours");
	  }
	  
	  if (xhr.status==200){

			Object.keys(json).forEach(function(key) {
		    value = json[key];
				
		    //console.log(document.getElementsByClassName("_"+key).length);
		    if (document.getElementsByClassName("_"+key).length>0){
		    //if (null!=document.getElementsByClassName("_"+key)){
		    	console.log("setting [_"+key+"] to ["+value+"]");
			    //$("#_"+key).text(value);
			    
			    $("._"+key).each(function(index) {
			    	resets[this.className]=$(this).text();
			    	$(this).text(value);
			    });
			    
		    	
		    	if (key=="level"){
						document.getElementsByClassName("_level")[0].src=ctx+"/../../images/"+value.toLowerCase()+"_belt_icon.png";
		    	}else{
		    	  //$("#_"+key).text(value);
		    		//document.getElementById("_"+key).innerText=value;
		    	}
		    }else{
		    	//console.log("NOT setting [_"+key+"] to ["+value+"]");
		    }
		    //console.log(value);
			});
			
			if (json['displayName']==undefined){
					$("._displayName").text(json['username']);
			}else{
				$("._displayName").text(json['displayName']);
			}
			
			if ("true"==json['admin']){
				document.getElementById("userSelect").innerHTML=`<input type='text' id='username' value='`+username+`'><input type='button' value='Go' onclick='_displ(document.getElementById("username").value); return false;'/>`;
			}
			
			document.getElementById("nav").height=document.getElementById("dashboard").height;
		}
	}
}

//alert('Display Name: ' + window.parent._jive_current_user.displayName +  
//'\nAnonymous: ' + window.parent._jive_current_user.anonymous+  
//'\nUsername: ' + window.parent._jive_current_user.username +  
//'\nID: ' + window.parent._jive_current_user.ID+  
//'\nEnabled: ' + window.parent._jive_current_user.enabled +  
//'\nAvatar ID: ' + window.parent._jive_current_user.avatarID);  
</script>




		

<script>
	Chart.pluginService.register({
		beforeDraw: function (chart) {
			if (chart.config.options.elements.center) {
        //Get ctx from string
        var ctx = chart.chart.ctx;
        
				//Get options from the center object in options
        var centerConfig = chart.config.options.elements.center;
      	var fontStyle = centerConfig.fontStyle || 'Arial';
      	var txt = centerConfig.text;
        var color = centerConfig.color || '#000';
        var sidePadding = centerConfig.sidePadding || 20;
        var sidePaddingCalculated = (sidePadding/100) * (chart.innerRadius * 2)
        //Start with a base font of 30px
        ctx.font = "30px " + fontStyle;
        
				//Get the width of the string and also the width of the element minus 10 to give it 5px side padding
        var stringWidth = ctx.measureText(txt).width;
        var elementWidth = (chart.innerRadius * 2) - sidePaddingCalculated;

        // Find out how much the font can grow in width.
        var widthRatio = elementWidth / stringWidth;
        var newFontSize = Math.floor(30 * widthRatio);
        var elementHeight = (chart.innerRadius * 2);

        // Pick a new font size so it will not be larger than the height of label.
        var fontSizeToUse = Math.min(newFontSize, elementHeight);

				//Set font settings to draw it correctly.
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        var centerX = ((chart.chartArea.left + chart.chartArea.right) / 2);
        var centerY = ((chart.chartArea.top + chart.chartArea.bottom) / 2);
        ctx.font = fontSizeToUse+"px " + fontStyle;
        ctx.fillStyle = color;
        
        //Draw text in center
        ctx.fillText(txt, centerX, centerY);
			}
		}
	});

function resetCanvas(chartElementName){
  $('#'+chartElementName).remove(); // this is my <canvas> element
  $('#'+chartElementName+'_container').append('<canvas id="'+chartElementName+'"><canvas>');
  var canvas = document.querySelector('#'+chartElementName);
  var ctx = canvas.getContext('2d');
  ctx.canvas.width = $('#'+chartElementName+'_container').width();
  ctx.canvas.height = $('#'+chartElementName+'_container').height()+100;
}

//var colors=["rgba(204,0,0,X)","rgba(0,65,83,X)","rgba(146,212,0,X)","rgba(163,219,232,X)","rgba(59,0,131,X)","rgba(240,171,0,X)","rgba(0,122,135,X)"];
//var colors2=["rgba(0,122,135,X)","rgba(240,171,0,X)","rgba(59,0,131,X)","rgba(163,219,232,X)","rgba(146,212,0,X)","rgba(0,65,83,X)","rgba(204,0,0,X)"];

var purple="rgba(59,0,131,X)";
var lightOrgange="rgba(240,171,0,X)";
var darkOrgange="rgba(236,122,8,X)";
var lightGreen="rgba(146,212,0,X)";
var darkGreen="rgba(63,156,53,X)";
var lightBlue="rgba(0,185,228,X)";
var vividBlue="rgba(0,136,206,X)";
var paleBlue="rgba(163,219,232,X)";
var tealBlue="rgba(0,122,135,X)";

var colors=[tealBlue,paleBlue,darkOrgange,darkGreen,lightBlue,lightOrgange,lightGreen,vividBlue]
var colorsReverse=colors.slice().reverse();
//var bcolors=["rgba(0,65,83,X)","rgba(0,136,206,X)","rgba(63,156,53,X)","rgba(236,122,8,X)","rgba(,X)","rgba(,X)"]


function buildChart(uri, chartElementName, type, clrs){
  var xhr = new XMLHttpRequest();
  xhr.open("GET", ctx+uri, true);
  xhr.send();
  xhr.onloadend = function () {
    var data=JSON.parse(xhr.responseText);
    var ctx = document.getElementById(chartElementName).getContext("2d");
    
  	var backgroundColor=[];
  	var borderColor=[];
  	for (i=0;i<data.datasets[0].data.length;i++){
  		backgroundColor[i]=clrs[i].replace("X","1"); // replace is the opacity
  		borderColor[i]=clrs[i].replace("X","0.8"); // replace is the opacity
  	}
  	data.datasets[0].backgroundColor=backgroundColor;// push({"backgroundColor2":backgroundColor});
  	data.datasets[0].borderColor=borderColor;
    
  	
  	var centerText="";
  	var total=0;
	  for(var i=0;i<data.datasets[0].data.length;i++)
	    total+=data.datasets[0].data[i];
  	
	  centerText=total;
	  if ("points"==chartElementName){
		  var current=data.datasets[0].data[0];
	    if (0==current && 0==total){
	      var centerText="0%";
	    }else
	    	var centerText=Math.round((current/total)*100)+"%";
	    
	  }
	  
	  
    if (type=="Doughnut"){
	    var myDoughnutChart = new Chart(ctx, {
			    type: 'doughnut',
			    data: data,
			    options: {
						elements: {
							center: {
								text: centerText,
								color: '#333',
			          //color: '#eee', // Default is #000000
			          fontStyle: 'Arial', // Default is Arial
			          sidePadding: 20, // Default is 20 (as a percentage)
			          labelFontSize: 5
							}
						},
						legend:{
							display: true,
							position: "bottom",
							labels: {
								//fontColor: "#eee",
								fontColor: "#333",
								fontSize: 12
							}
						}
					}
			});
    }
  }
}

var graphs={
  "points":         "/nextLevel_"+getUsername(),
  "breakdown":      "/breakdown_"+getUsername(),
};

function refreshGraph0(graphName, type, colors){
  buildChart(graphs[graphName], graphName, type, colors);
}
function refresh(){
	leaderboardRefresh();
	breakdownRefresh();
}
//refresh();
</script>
</div>
</center>
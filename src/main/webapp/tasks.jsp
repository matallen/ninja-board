<%@page import="
java.util.Date,
java.util.Calendar
"%>


<html lang="en">
<head>

<%@include file="header.jsp"%>

<%@include file="nav.jsp"%>

		<div class="navbar-connector"></div>
    <div class="navbar-title">
    	<h2><span class="navbar-title-text">Tasks</span></h2>
    </div>
    
    <link rel="stylesheet" href="https://raw.githack.com/riktar/jkanban/master/dist/jkanban.min.css">
    <link rel="stylesheet" href="css/tasks.css">
    
		<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/solid.css" integrity="sha384-+0VIRx+yz1WBcCTXBkVQYIBVNEFH1eP6Zknm16roZCyeNg2maWEpk/l/KsyFKs7G" crossorigin="anonymous">
		<!--link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/regular.css" integrity="sha384-aubIA90W7NxJ+Ly4QHAqo1JBSwQ0jejV75iHhj59KRwVjLVHjuhS3LkDAoa/ltO4" crossorigin="anonymous"-->
		<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.6.3/css/fontawesome.css" integrity="sha384-jLuaxTTBR42U2qJ/pm4JRouHkEDHkVqH0T1nyQXn1mZ7Snycpf6Rl25VBNthU4z0" crossorigin="anonymous">

    <link href="https://fonts.googleapis.com/css?family=Lato" rel="stylesheet">

    <style>
        body {
            font-family: "Lato";
            margin: 0;
            padding: 0;
            width: 100%;
        }
        #myKanban {
            overflow-x: auto;
            padding: 20px 0;
            width: 95%;
        }
        .success {
            background: #00B961;
        }
        .info {
            background: #2A92BF;
        }
        .warning {
            background: #F4CE46;
        }
        .error {
            background: #FB7D44;
        }
    </style>
</head>
<body>
<div id="myKanban"></div>


 <!-- Modal -->
 <div class="modal fade" id="details" role="dialog">
   <div class="modal-dialog">
     <!-- Modal content-->
     <div class="modal-content">
       <div class="modal-header">
         <button type="button" class="close" data-dismiss="modal">&times;</button>
         <h4>
         <!--div class="drag-modal ui-draggable-handle"-->
         <!--
           <i class="drag-handle fa fa-ellipsis-v" style="height:20px;"></i>
           <i class="drag-handle fa fa-ellipsis-v" style="height:20px;"></i>
         -->
         <!--/div-->
           <span class="modal-title">Modal Header</span>
         </h4>
       </div>
       <div class="modal-body container-fluid">
         <div class="row">
           <div class="card-main col-md-10">
             <div class="top">
               <h5 class="issue-title">issue-title</h5>
               
               <div class="card-comment">
                 <a href="https://github.com/matallen">
                   <img class="card-comment-avatar img-rounded" height="40" width="40" src="https://avatars3.githubusercontent.com/u/3470466?v=4">
                 </a>
                 <div class="card-comment-item">
                   <div class="card-comment-header">
                     <span class="">Description</span>
                     <button class="btn-icon pull-right btnCommentDelete"><i class="fa fa-times action-menu-icon" title="Delete this comment"></i></button>
                     <button class="btn-icon pull-right btnCommentEit"><i class="fa fa-pencil-alt action-menu-icon" title="Edit this comment"></i></button>
                   </div>
                   <div class="card-comment-body">
                     <p>some description</p>
                   </div>
                   <div class="card-comment-body card-comment-body-edit hidden">
                     <textarea>some description</textarea>
                   </div>
                 </div>
               </div>
               
               <div class="card-comment">
                 <a href="https://github.com/matallen">
                   <img class="card-comment-avatar img-rounded" height="40" width="40" src="https://avatars3.githubusercontent.com/u/3470466?v=4">
                 </a>
                 <div class="card-comment-item">
                   <div class="card-comment-header">
                     <a href="https://github.com/matallen"><span class="">matallen</span></a> commented 21 days ago
                     <button class="btn-icon pull-right btnCommentDelete"><i class="fa fa-times action-menu-icon" title="Delete this comment"></i></button>
                     <button class="btn-icon pull-right btnCommentEit"><i class="fa fa-pencil-alt action-menu-icon" title="Edit this comment"></i></button>
                   </div>
                   <div class="card-comment-body">
                     <p>some comment</p>
                   </div>
                   <div class="card-comment-body card-comment-body-edit hidden">
                     <textarea>some comment</textarea>
                   </div>
                 </div>
               </div>
               
               <div class="divider"></div>
               
               <!-- add comment box -->
               <div class="comment-form">
                 <div class="tabset ng-isolate-scope">
                   <ul class="nav nav-tabs">
                     <li class="active"><a href="">Write</a></li>
                     <li disabled="disabled" class="disabled"><a href="#" disabled>Preview</a></li>
                   </ul>
                   <div class="tab-content">
                     <div>
                       <textarea class="form-control" tabindex="4" autocomplete="off" style="overflow: hidden; overflow-wrap: break-word; resize: none; height: 54px;"></textarea>
                     </div>
                   </div>
                   <div class="footer">
                     <button class="animate btn btn-primary pull-right comment-btn" tabindex="7" data-loading-text="Commenting..." disabled="disabled">Comment</button>
                     <!-- if state != CLOSED -->
                     <button class="animate btn btn-default pull-right comment-close-btn" tabindex="8" data-loading-text="Closing...">Close issue</button>
                   </div>
                 </div>
               </div>
             </div>
           </div>
           
           <style>
    .animate{
      transition: all .3s;
    }
    .comment-form{
      background-color: #f6f6f6;
      border: 1px solid #cdcdcd;
      -webkit-border-radius: 6px;
      -moz-border-radius: 6px;
      border-radius: 6px;
    }
    .comment-form .nav-tabs{
      padding: 8px 10px 0;
    }
    /*
    .nav-tabs {
      border-bottom: 1px solid #ddd;
    }
    */
    .nav {
      padding-left: 0;
      margin-bottom: 0;
      list-style: none;
    }
    .comment-form .tab-content {
      background-color: #fff;
      padding: 4px;
      overflow: auto;
    }
    .comment-form .footer {
      background-color: #fff;
      padding: 0 4px 4px;
      width: 100%;
      overflow: auto;
      -webkit-border-top-right-radius: 0;
      -webkit-border-bottom-right-radius: 6px;
      -webkit-border-bottom-left-radius: 6px;
      -webkit-border-top-left-radius: 0;
      -moz-border-radius-topright: 0;
      -moz-border-radius-bottomright: 6px;
      -moz-border-radius-bottomleft: 6px;
      -moz-border-radius-topleft: 0;
      border-top-right-radius: 0;
      border-bottom-right-radius: 6px;
      border-bottom-left-radius: 6px;
      border-top-left-radius: 0;
      -moz-background-clip: padding-box;
      -webkit-background-clip: padding-box;
      background-clip: padding-box;
    }
           
           </style>
           
           
           <div class="card-sidebar col-md-3">
             <div class="status">
               <span class="closed">CLOSED</span>
             </div>
             <div class="horizontal-divider"></div>
             <div class="assignee-container sidebar-options">
               <button class="option-button" data-toggle="dropdown">
                 <span>Assignees</span>
                 <i class="fa fa-cog menu-toggle-icon"></i>
               </button>
               <!-- real dropdown users menu goes here -->
               <p class="option-placeholder ng-scope" ng-if="!card.githubMetadata.assignees.length">Unassigned</p>
             </div>
             <div class="sizing-container sidebar-options">
               <button class="option-button" data-toggle="dropdown">
                 <span>Size/Estimate</span>
                 <i class="fa fa-cog menu-toggle-icon"></i>
               </button>
             </div>
             <div class="labels-container sidebar-options">
               <button class="option-button" data-toggle="dropdown">
                 <span>Labels</span>
                 <i class="fa fa-cog menu-toggle-icon"></i>
               </button>
               <div class="labels">
                 <span ng-repeat="label in displayLabels track by label.name" class="label-pill ng-scope light" bo-class="lightOrDark(label)" bo-style="{'background-color': '#'+label.color}" bo-html="label.displayName" labels="card.githubMetadata.labels" style="background-color: rgb(162, 238, 239);">enhancement</span>
                 <div class="option-placeholder">No Labels</div>
               </div>
             </div>
           </div>
         </div>
       </div>
       <div class="modal-footer">
         <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
       </div>
     </div>
   </div>
 </div>
 

<!--
<input type="text" id="newItem" /><button disabled id="addToDo">Add</button>
<script src="https://raw.githack.com/riktar/jkanban/master/dist/jkanban.min.js"></script>
-->
<script src="js/jkanban.js"></script>

<style>
.w-5{width:5%;}
.w-10{width:10%;}
.w-20{width:20%;}
.w-30{width:30%;}
.w-40{width:40%;}
.w-50{width:50%;}
.card .title{
	font-size: 14px;
  border: 1px solid transparent;
  border-radius: 3px;
  box-sizing: border-box;
  color: #525252;
  line-height: 18px;
  margin: 0;
  min-height: 22px;
  overflow: hidden;
  padding: 2px 2px 0;
  resize: none;
  white-space: normal;
	width:92%;
/*
*/
}
.field{
  vertical-align: top;
}
.action-btn{
	height: 20px;
	width: 20px;
	padding: 0px 20px 0px 0px;
	margin: 0px;
	/* remove button borders*/
  border-color: transparent;
	background-color: transparent;
  -webkit-box-shadow: none;
  box-shadow: none;
}
.up-arrow, .up-arrow-inner{
	position: absolute;
  color: #fefefe;
  right: 12px;
  border-style: solid;
  height: 0;
  width: 0;
}
.up-arrow{
    top: -15px;
    border-color: #b1b1b1 transparent;
    border-width: 0 10px 15px;
}
.up-arrow-inner{
		top: -12px;
    border-color: #fefefe transparent;
    border-width: 0 10px 14px;
}
.checkmark{ opacity:0; color:#525252; }
.checkmark.is-picked{ opacity: 1 }

.modal-dialog{
	width: 40%;
}
.modal-header{
  background-color: #343434;
  padding: 1px;
}
.card-main{
  width: 75%;
}
.card-sidebar{
  float: right;
}
.drag-handle{
  height:15px;
  width: 0;
  padding: 0;
}
.modal-title{
	color: white;
	padding: 20;
}
h4{
  margin: 4;
}
.card-comment-item{
  margin: 0 0 20px 58px;
}
.card-comment-header{
  -webkit-border-top-right-radius: 5px;
  -webkit-border-bottom-right-radius: 0;
  -webkit-border-bottom-left-radius: 0;
  -webkit-border-top-left-radius: 5px;
  -moz-border-radius-topright: 5px;
  -moz-border-radius-bottomright: 0;
  -moz-border-radius-bottomleft: 0;
  -moz-border-radius-topleft: 5px;
  border-top-right-radius: 5px;
  border-bottom-right-radius: 0;
  border-bottom-left-radius: 0;
  border-top-left-radius: 5px;
  -moz-background-clip: padding-box;
  -webkit-background-clip: padding-box;
  background-clip: padding-box;
  font-size: 14px;
  line-height: 33px;
  padding-left: 6px;
  
    background-color: #f6f6f6;
    border: 1px solid #dfdfdf;
    border-radius: 0;
    color: #8b8b8b;
    display: block;
    font-size: 13px;
    font-weight: 700;
    line-height: 30px;
    padding: 0 10px 0 15px;
    position: relative;
}

.card-comment-header:after,
.card-comment-header:before{
    border: solid transparent;
    content: " ";
    height: 0;
    position: absolute;
    right: 100%;
    top: 17px;
    width: 0;
}

.card-comment-header:before{
    border-right-color: #dfdfdf;
    border-width: 11px;
    margin-top: -11px;
    

}
.card-comment-header:after{
    border-right-color: #f6f6f6;
    border-width: 10px;
    margin-top: -10px;
}
.card-comment-avatar{
    border-radius: 6px;
    float: left;
    margin: 0;
    position: relative;
    height: 40px;
    width: 40px;
}
.card-comment-body{
    padding: 15px;
    box-sizing: border-box;
    background-color: #fff;
    border: 1px solid #e6e6e6;
    border-top: none;
    margin: 0;
    color: #525252;
    -webkit-border-top-right-radius: 0;
    -webkit-border-bottom-right-radius: 5px;
    -webkit-border-bottom-left-radius: 5px;
    -webkit-border-top-left-radius: 0;
    -moz-border-radius-topright: 0;
    -moz-border-radius-bottomright: 5px;
    -moz-border-radius-bottomleft: 5px;
    -moz-border-radius-topleft: 0;
    border-top-right-radius: 0;
    border-bottom-right-radius: 5px;
    border-bottom-left-radius: 5px;
    border-top-left-radius: 0;
    -moz-background-clip: padding-box;
    -webkit-background-clip: padding-box;
    background-clip: padding-box;
    overflow: auto;
    width: 100%;
}
.btn-icon{
    height: 30px;
    width: 30px;
    padding: 3 0 3 0; /*top & bottom*/
    margin: 0px;
    border-color: transparent;
    background-color: transparent;
    -webkit-box-shadow: none;
    box-shadow: none;
}
button:focus{outline:0;}
/*

.icon-pencil:before{
    content: "\F058";
}
.icon{
    cursor: pointer;
    padding: 9px 4px;
    transition: color .3s;
    font: normal normal 16px github;
    line-height: 1;
    display: inline-block;
    text-decoration: none;
    -webkit-font-smoothing: antialiased;
}
.icon{
    cursor: pointer;
    padding: 9px 4px;
    transition: color .3s;
    line-height: 1;
}
*/
.img-rounded{
  border-radius: 6px;
}
.hidden{
  display: none;
}
.card-sidebar .status{
    display: block;
    margin-bottom: 5px;
    padding: 0;
    text-align: center;
}
.sidebar-options{
  margin: 20 0 20 0;
  padding: 0;
}
.card-sidebar .option-button{
    color: #828282;
    background: none;
    border: none;
    padding: 3 0 3 0;
    font-size: 18px;
    margin: 0;
    text-align: left;
    transition: all .3s;
    width: 100%;
    height: 30px;
}
.card-sidebar .option-button:hover,
.card-sidebar .option-button:active,
.card-sidebar .option-button:focus{
    color: #222;
}
.card-sidebar .menu-toggle-icon{
    height: 30px;
    width: 30px;
    color: #b1b1b1;
    float: right;
    transition: all .3s;
    padding: 4;
    margin: 0;
}
/*
.menu-toggle-icon:hover, .menu-toggle-icon:active, .menu-toggle-icon:focus {
    color: #525252;
}
*/
</style>

<script>

var users=[
	{"name":"Mat Allen", "username":"matallen", "id":"3470466"},
	{"name":"Andrew Block", "username":"saber1041", "id":"1191285"}
];

$(document).ready(function() {
	Http.httpGet("${pageContext.request.contextPath}/api/tasks", function(response){
		
		var j=JSON.parse(response);
		var todo=j.todo;
		var working=j.working;
		var done=j.done;
		
		
		//console.log("response="+j);
		//console.log("response.todo="+j.todo);
		//$('#alertsEnabled').prop("checked", "true"==response.toLowerCase());
		
		var id=0;
		
    var KanbanTest = new jKanban({
        element: '#myKanban',
        gutter: '10px',
        widthBoard: '450px',
        dragBoards: false,
        contextMenu: true,
        deleteCards: true,
        checklists: false,
        comments: false,
        userAssignment: true,
        labels: true,
        onLabelNew: function(el, nodeItem, addLabel){
          console.log("onLabelNew():: el.value="+el.value+", el.dataset="+JSON.stringify(el.dataset) +", nodeItem="+JSON.stringify(nodeItem.dataset));
          if (undefined==el.value || el.value=="") return;
          Http.httpPost("${pageContext.request.contextPath}/api/tasks/"+el.dataset.id+"/labels/"+el.value, null, function(response, status){
            if (status==200)
            	addLabel(el, el.dataset.id, el.value);
          });
        },
        onLabelDelete: function(el, nodeItem, removeLabel){
          console.log("onLabelDelete():: el="+JSON.stringify(el.dataset) +", nodeItem="+JSON.stringify(nodeItem.dataset));
          Http.httpDelete("${pageContext.request.contextPath}/api/tasks/"+el.dataset.id+"/labels/"+el.dataset.label, null, function(response, status){
            if (status==200)
            	removeLabel(el, el.dataset.id, el.value);
          });
        },
        loadUsers: function(){
        	console.log("loadUsers():: users="+users);
        	return users;
        },
        getAssigned: function(cardId){
        	
        },
        //loadAssigned: function (cardId){
        //  console.log("loadAssigned():: for cardId="+cardId);
        //},
        onAssignUser: function(cardId, userId, addUser){
        	console.log('onAssignUser():: card '+cardId+', toggled user '+userId);
        	// add user to card
        	Http.httpPost("${pageContext.request.contextPath}/api/tasks/"+cardId+"/assigned/"+userId, null, function(response, status){
            if (status==200)
            	addUser(cardId, userId);
          });
        },
        onUnassignUser: function(cardId, userId, removeUser){
        	console.log('onUnassignUser():: card '+cardId+', toggled user '+userId);
        	// remove user from card
        	Http.httpDelete("${pageContext.request.contextPath}/api/tasks/"+cardId+"/assigned/"+userId, null, function(response, status){
            if (status==200)
        	    removeUser(cardId, userId);
          });
        	
        },
        onUserAssignmentDelete: function(el, nodeItem, removeLabel){
        	// remove user from card
        },
        
        onUpdate: function(el, nodeItem, updateTitle){
        	console.log("onUpdate():: el="+el.value +", nodeItem="+JSON.stringify(nodeItem.dataset));
        	
        	var data={"title":el.value};
        	Http.httpPost("${pageContext.request.contextPath}/api/tasks/"+nodeItem.dataset.eid, data, function(response, status){
		   				// TODO: get the status and change only if it's a 200 - for now, just hope it went ok
		   				if (status==200){
		   					updateTitle(el, el.dataset.id, el.value);
		   				}
		    	});
        	
        },
        onCardDelete: function(el){
        	console.log("onDelete():: el="+JSON.stringify(el.dataset));
        	Http.httpPost("${pageContext.request.contextPath}/api/tasks/"+el.dataset.eid+"/delete", null, function(response){
       				KanbanTest.removeElement(el.dataset.eid);
        	});
        },
        //customDisplay: function(boardId, el, data){
        //	console.log("customDisplay():: el="+JSON.stringify(el.dataset));
        //	
        //	return "<textarea id='title_"+data.id+"' style='height:10px' class='title'>"+data.title+"</textarea><br/><span style='border: 3px solid transparent'>"+data.timestamp.substring(0,10)+"</span>";
        //	
        //	
        //	//return "<div class='card'>"+
        //	//			 "<div class='header'><a class='id' href=''>"+id+"</a><span class='right'><button onclick=''><i class='unassigned fa fa-user'></i></button></span></div>"+
        //	//			 "<div class='body'><textarea class='title' onblur='card_title_update(\""+data.id+"\",this);'>"+data.title+"</textarea></div>"+
        //	//			 "<div class='footer clearfix'><div class='footer-labels'></div>"+
        //	//			 "<div class='footer-actions right'>"+
        //	//			   "<button><i class='fas fas-comment-alt'></i></button>"+
        //	//			   "<button><i class='fa fa-dots'></i></button>"+
        //	//			 "</div></div>"+
        //	//			 "</card>";
        //	//
        //	//return "<table><tr><td>"+data.title+"</td></tr><tr><td>"+data.user+"</td></tr><tr><td>"+data.timestamp.substring(0,10)+"</td></tr></table>";
        //	//
        //	//return "<table><tr><td>"+data.title+"</td></tr><tr><td>"+data.timestamp.substring(0,10)+"</td></tr></table>";
        //},
        //click: function (el) {
        //	console.log("onClick: "+el.dataset.eid);
        //	//
        //	//Http.httpPost("${pageContext.request.contextPath}/api/tasks/"+el.dataset.eid+"/delete", null, function(response){
        //	//	// update board to show removal of task?
        //	//});
        //	
        //    //console.log("Trigger on all items click!");
        //},
        dropEl:function (el, target, source, sibling) {
        	
        	var taskGuid=el.dataset.eid;
        	var taskTitle=el.innerText;
        	var sourceBoardName=source.offsetParent.dataset.id;
        	var targetBoardName=target.offsetParent.dataset.id;
        	
        	console.log("dragged from "+sourceBoardName+" to "+targetBoardName+" - title="+taskTitle+ " - guid="+taskGuid);
        	
        	var data={'list':targetBoardName};
        	Http.httpPost("${pageContext.request.contextPath}/api/tasks/"+taskGuid, data, function(response){
        		//need to figure out how to update the task to say its been dragged
        	});
        	
        },
//        buttonClick: function (el, boardId) {
//            console.log("el="+el);
//            console.log("boardId="+boardId);
//            // create a form to enter element 
//            var formItem = document.createElement('form');
//            formItem.setAttribute("class", "itemform");
//            formItem.innerHTML = '<div class="form-group"><textarea id="new" class="form-control" rows="2" autofocus></textarea></div><div class="form-group"><button type="submit" class="btn btn-primary btn-xs pull-right">Submit</button><button type="button" id="CancelBtn" class="btn btn-default btn-xs pull-right">Cancel</button></div>'
//            KanbanTest.addForm(boardId, formItem);
//            formItem.addEventListener("submit", function (e) {
//                console.log("submit pressed");
//                var title=$("#new").innerText();
//                console.log("title="+title);
//                var data='{"title":'+title+', "labels":labels}';
//                
//                //Http.httpPost("${pageContext.request.contextPath}/api/tasks", JSON.stringify(data), function(response){
//                //  
//                //});
//                e.preventDefault();
//                var text = e.target[0].value
//                KanbanTest.addElement(boardId, {
//                    "title": text,
//                })
//                formItem.parentNode.removeChild(formItem);
//            });
//            document.getElementById('CancelBtn').onclick = function () {
//                formItem.parentNode.removeChild(formItem)
//            }
//        },
        addItemButton: false,
        boards: [
            {
                "id": "_todo",
                "title": "To Do",
                "class": "info,good",
                "item": todo
            },
            {
                "id": "_working",
                "title": "Working",
                "class": "info,good",
                "item": working
            },
            {
                "id": "_done",
                "title": "Done",
                "class": "success",
                "item": done
            }
        ]
    });
    
    //$(document).on('click', "#newItem", function() {
		//	document.getElementById("addToDo").disabled=document.getElementById("newItem").value.length>0;
		//});
    
    //var toDoButton = document.getElementById('addToDo');
    //toDoButton.addEventListener('click', function () {
    //	  var newItem={"title":document.getElementById("newItem").value};
    //	  console.log("item text = "+newItem);
    //    
    //    Http.httpPost("${pageContext.request.contextPath}/api/tasks", newItem, function(response){
    //	  document.getElementById("newItem").value="";
	  //      // if server created the task, then show it on the kanban board
    //    	KanbanTest.addElement(
	  //          "_todo",
	  //          {
	  //              "id": response,
	  //              "title": newItem.title,
	  //          }
	  //      );
    //    });
    //  
    //});
	});
	
	
	//$('.dropdown-togglex').dropdown()
	
});




</script>
</body>
</html>


<!--
<div style="display:none" class="dropdown-menu waffle-dropdown-menu assignees-dropdown-menu ng-scope ng-isolate-scope" card="card" ng-if="expanded">
  <div class="up-arrow"></div>
  <div class="up-arrow-inner"></div>

  <div class="text-center waffle-dropdown-menu-header">
    <p>Assign up to 10 people to this card</p>
    <input type="text" ng-model="assigneeSearch.login" placeholder="Filter people" class="form-control js-assignee-search ng-pristine ng-valid">
  </div>

  <ul class="text-left waffle-dropdown-menu-list" ng-click="$event.stopPropagation()">
    <li class="waffle-dropdown-menu-list-item" ng-click="setAssignees()">
      <i class="fa fa-times-circle-o clear-selection-icon" aria-hidden="true"></i>
      <span class="clear-selection-text">Clear assignees</span>
    </li>
    <li ng-hide="possibleAssignees" class="text-center ng-hide"><i class="fa fa-spinner fa-spin"></i></li>
    <li class="waffle-dropdown-menu-list-item ng-scope" bindonce="" ng-repeat="assignee in possibleAssignees | filter:assigneeSearch track by assignee.login" ng-class="{highlight: ($index === 0 &amp;&amp; assigneeSearch)}" ng-click="setAssignees(assignee)">
      <i ng-class="{'is-picked': isActiveAssignee(assignee)}" class="fa fa-check checkmark"></i>
      <img bo-src="assignee.avatarUrl" class="img-circle" src="https://avatars3.githubusercontent.com/u/3470466?v=4">
      <span class="user-login" bo-text="assignee.login">matallen</span>
    </li>
  </ul>
  <button class="close-btn btn" ng-click="close()">Close</button>
</div>
-->

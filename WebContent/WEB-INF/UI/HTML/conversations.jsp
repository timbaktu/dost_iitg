<%@taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
	<jsp:include page="includes/commonHeader.jsp"></jsp:include>
	
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/CSS/jquery.more.css"> 
	<script src="${pageContext.request.contextPath}/resources/JS/jquery.plugin.js" type="text/javascript"></script>
	<script src="${pageContext.request.contextPath}/resources/JS/jquery.more.js" type="text/javascript"></script>
<script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
	<script>
	
	var selected_recepient = "" ;
	
	/*Manipulating json for messages*/
	$( document ).ready(function() {
		$(".loading").show();
		var userid;
		var redirected = window.location.href.split("=");
		var UrlForData;
		
		if(redirected[1]=='chat'){
			setTimeout(function(){
				$( ".leaveMessage" ).trigger( "click" );
			},2000);
		}
		
		/*Sent messages and inbox toggle active class*/
		$(".sentItems").click(function(){
			$(".sentItems").removeClass("active");
			$(this).addClass("active");
			UrlForData = '/dost/api/user/'+userid+'/sentmessages';
			
			showData(UrlForData);
		});
		
		$(".chats").click(function(){
			$(".chats").removeClass("active");
			$(this).addClass("active");
			UrlForData = '/dost/api/chathistory/user/' + userid ;
			
			showData(UrlForData);
		});

		$(".inbox").click(function(){
			$(".sentItems").removeClass("active");
			$(this).addClass("active");
			UrlForData = '/dost/api/user/'+userid+'/messages';
			showData(UrlForData);
		});
		/*End Of Sent messages and inbox toggle active class*/
		
		$.getJSON("/dost/api/user/${pageContext.request.userPrincipal.name}", function(user) {
			userid = user.userId;
			 UrlForData = '/dost/api/user/'+userid+'/messages';
			 showData(UrlForData);
		});
		
		/* Unread message count*/
		$.getJSON("/dost/api/user/${pageContext.request.userPrincipal.name}", function(user) {
			userid = user.userId;
			 UrlForData = '/dost/api/user/'+userid+'/unreadcount';
				$.getJSON(UrlForData, function(count) {	
					var unreadcount = count[userid];
					if(unreadcount > 0) {
						$('#count').text('Inbox(' + unreadcount +  ')');
					}
					else {
						$('#count').text('Inbox');
					}
				});
		});
		
		function showData(UrlForData){
			$.getJSON(UrlForData, function(messages) {	
				$(".loading").hide();
			$(".conversationsUser").html("");
			$(".conversationsCounselor").html("");
			
			if(messages.length>0){
					for (var i = 0 ; i < messages.length; i++) {
						
						if( messages[i].recipients.length == 0 ) continue ;
						
						var ismessagenew = messages[i].recipients[0].viewed;
						var messageHeading = '';
						
						// 1 means viewed
						if(ismessagenew == 0) {
							messageHeading = '<h4 class="media-heading unread" style="font-weight:bold">'+messages[i].subject+'</h4>';
						}
						else {
							messageHeading = '<h4>'+messages[i].subject+'</h4>';
						}						
						
						$(".conversationsUser").append('<li class="well media conversation_topic">'+
							'<div class="each_conversation" id="conversationsExpanded?='+messages[i].msgId+'">'+
								'<div class="pull-left col-md-2" href="#">'+
									'<div class="friend_name"><img class="avatar" id='+messages[i].sender.avatar+' src=avatar/'+messages[i].sender.avatar+'.png name='+messages[i].sender.avatar+ '/></div>'+
									'<div class="friend_name">'+messages[i].sender.username+'</div>'+
									'<div class="date_of_conversation">'+messages[i].sentDate+'</div>'+
								'</div>'+
								'<div class="media-body col-md-8">'+
										messageHeading +
										'<div class="wrapperConversations">'+messages[i].content+'</div>'+
								'</div>'+
								'<div class="pull-right col-md-1">'+
									'<div title="view complete conversation" href="conversationsExpanded?='+messages[i].msgId+'">View'+
										'<span class="glyphicon glyphicon-chevron-right"></span>'+
									'</div>'+
								'</div>'+
								'<div class="clearfix"></div>'+
							'</div>'+
						'</li>');
						
						<!-- open the conversation detail for user -->
						
						$(".each_conversation").click(function(){
							var link = $(this).attr("id");
							window.open(link,"_self");
						});
						<!-- end of click to open the conversation for user-->
						
					}
			
					for (var j = 0 ; j < messages.length; j++) {
						var ismessagenew = messages[j].recipients[0].viewed;
						var messageHeading = '';
						
						// 1 means viewed
						if(ismessagenew == 0) {
							messageHeading = '<h4 class="media-heading unread" style="font-weight:bold">'+messages[j].subject+'</h4>';
						}
						else {
							messageHeading = '<h4>'+messages[j].subject+'</h4>';
						}
												
						
						$(".conversationsCounselor").append('<li class="well media conversation_topic">'+
							'<a class="each_conversation" href="conversationsExpanded?='+messages[j].msgId+'">'+
								'<div class="pull-left col-md-2" >'+
									'<div class="friend_name"><img class="avatar" id='+messages[j].sender.avatar+' src=avatar/'+messages[j].sender.avatar+'.png name='+messages[j].sender.avatar+ '/></div>'+
									'<div class="friend_name">'+messages[j].sender.username+'</div>'+
								'</div>'+
								'<div class="pull-left media-body col-md-7">'+
								messageHeading + 
								'<span style="conversation_summary">'+messages[j].content+'</span>'+
								'</div>'+
								'<div class="pull-left">'+messages[j].sentDate+'</div>'+
								'<div class="pull-right col-md-1">'+
									'<div title="view complete conversation" href="conversationsExpanded?='+messages[j].msgId+'">'+
										'<span class="glyphicon glyphicon-chevron-right"></span>'+
									'</div>'+
								'</div>'+
							'</a>'+
							'<div class="clearfix"></div>'+
						'</li>');
					}
					
					/*for highlighting unread conversations*/
					$(".unread").closest("li").addClass("unreadConversations");
					
					/*for highlighting unread conversations*/	
				}
				else{
					$(".conversations").html('<div class="noConversationsText">There are no conversations <br/> <a class="leaveMessageLink">Leave a message</a></div>'); 
				}
				});
		}
		
		$(".conversations").on("click",".leaveMessageLink", function(){
			$( ".leaveMessage" ).trigger( "click" );	
		});
		
		/*Showing Ellipsis - dotdotdot plugin*/
		setTimeout(function(){
			$('.wrapperConversation').more({length: 120});
		},1000);
		/*End of showing ellipsis*/
		
		
		var receipient = 'all' ; /*to go as receipientID*/
		
		/*populating users*/
			function split( val ) {
			return val.split( /,\s*/ );
		}
		function extractLast( term ) {
			return split( term ).pop();
		}

		/*
		$("#recipient" ).autocomplete({
			source: function( request, response ) {
	                $.ajax({
	                    url: "/dost/api/users",
	                    dataType: "json",
	                    data: {term: request.term},
	                    success: function(data) {
	                    	var arr =  $.map(data, function(users) {
                            	return {
                                label: users.username,
                                name: users.userId,
                                };
                            });   
	                    	console.log( arr ) ;	
	                    	response( arr );
	                        }
	                    });
	                },
	         minLength: 2,
	         select: function( event, ui ) {
					var terms = split( this.value );
					// remove the current input
					terms.pop();
					// add the selected item
					terms.push( ui.item.value );
					// add placeholder to get the comma-and-space at the end
					terms.push( "" );
					receipient = ui.item.label;
					this.value = terms.join( ", " );
					return false;
				}
		});*/
		
		/*end of populating users*/
		
		/*send Message popup*/
		
		
		$(".leaveMessage").click(function(){
			$("#dialogMessage").dialog("open");
			$('.ui-widget-overlay').css('background', 'white');
		});
		
		$("#dialogMessage").dialog({
				modal: true,
				autoOpen : false,
				width : 600,
				buttons : [ {
					text : "CANCEL",
					click : function() {
						$(this).dialog("close");
					}
				}, 
				{
					text : "SEND",
					click : function() {
							$(".error").html("");
							$(".error").hide();
							
							var selected_recipient = $("#selected_recipient").val() ;
							if( selected_recipient == undefined || selected_recipient == '' || !selected_recipient ){
								selected_recipient = "all" ;
							}
														
							var datatosend = 'subject='+$("#subject").val()+'&content=' + $("#messageContent").val()+ '&recipients='+ selected_recipient +'&senderId=' + userid;
							//alert(datatosend);						 
							if($("#recipient").val()== '' || $("#subject").val()== '' || $("#messageContent").val() =='') {
								$(".error").show().text("Please fill in details");
							}
							else{
								
								$.post('/dost/api/user/message', datatosend, function(response) {							
									if(response = ""){
											$(".status").show().html("sending..");
									}
								});
								
								setTimeout(function(){
									/*location.reload(function(){
										
										
										
									});*/
									$(".status").show().html("sent");
									$("#dialogMessage").dialog("close");
									$('.ui-widget-overlay').hide() ;
								}, 1000);
								receipient = 'all';
							}
					}
				}]	
		});	
		
		/*End of send message popup*/	
			
		
		/*Sent messages and inbox toggle active class*/
		$(".sentItems").click(function(){
			$(".inbox").removeClass("active");
			$(this).addClass("active");
		});
		$(".Inbox").click(function(){
			$(".sentItems").removeClass("active");
			$(this).addClass("active");
		});
		/*End Of Sent messages and inbox toggle active class*/
		
	});
	/*End of manipulating json for messages*/	
	
	</script>
	
	
	<sec:authorize access="hasRole('ROLE_ADMIN')">
	
	<body class="theme-default theme-default-counselor" >
	</sec:authorize>
	<sec:authorize access="!hasRole('ROLE_ADMIN')">
	<body class="theme-default">
	</sec:authorize>
	
		<jsp:include page="includes/header.jsp"></jsp:include>
		<sec:authorize access="hasRole('ROLE_ADMIN')">
			<div class="container">
				<div class="col-md-11">
					<div class="pageTop">
						<h2 class="pull-left pageHeading">Conversations</h2>
						<div class="pull-right">
							<!--<ul class="pagination">
							  <li class="disabled"><a href="#">&laquo;</a></li>
							  <li class="active"><a href="#">1 <span class="sr-only">(current)</span></a></li>
							  <li><a href="#">2</a></li>
							  <li><a href="#">3</a></li>
							  <li><a href="#">4</a></li>
							  <li><a href="#">5</a></li>
							  <li><a href="#">&raquo;</a></li>
							</ul>  -->
						</div>
						<div class="clearfix"></div>
					</div>
					
					<ul class="pull-left col-md-2 left_nav">
						<li><a class="leaveMessage" href="#">Compose</a><br/><br/></li>
						<li class="active inbox"><a id="count" href="#">Inbox</a></li>
						<li class="sentItems"><a href="#">Sent Items</a></li>
						<li class="chats"><a href="#">Chats</a></li>
						<!-- <li><a href="#">Drafts</a><br/><br/></li>
						<li><a href="#">Label 1</a></li>
						<li><a href="#">Label 2</a></li>  -->
					</ul>
					<ul class="pull-right conversations conversationsCounselor col-md-10">
						<li class="loading" id="loading">
							<img src="${pageContext.request.contextPath}/resources/img/ajax-loader.gif" alt="Loader" />
						</li>
					</ul>
						
				</div>
				<div class="status col-md-11"></div>
			</div>
		 </sec:authorize>
		 
		 <sec:authorize access="!hasRole('ROLE_ADMIN')">
			<div class="container">
				<div class="col-md-11">
					<div class="pageTop">
						<h2 class="pull-left pageHeading">Conversations</h2>
						<div class="pull-right">
							<!-- <ul class="pagination">
							  <li class="disabled"><a href="#">&laquo;</a></li>
							  <li class="active"><a href="#">1 <span class="sr-only">(current)</span></a></li>
							  <li><a href="#">2</a></li>
							  <li><a href="#">3</a></li>
							  <li><a href="#">4</a></li>
							  <li><a href="#">5</a></li>
							  <li><a href="#">&raquo;</a></li>
							</ul> -->
							<a href="talkToFriend" class="btn btn-primary btn-large login_btn">Speak to friend online</a>
							<input type="button" class="leaveMessage btn btn-primary btn-large login_btn" value="Leave a message to your friend"></input>
						</div>
						<div class="clearfix"></div>
					</div>
					<!-- each conversation-->
					<ul class="pull-left col-md-2 left_nav">
						<li><a class="leaveMessage" href="#">Compose</a><br/><br/></li>
						<li class="active inbox"><a id="count" href="#">Inbox</a></li>
						<li class="sentItems"><a href="#">Sent Items</a></li>
						<li class="chats"><a href="#">Chats</a></li>
						<!-- <li><a href="#">Drafts</a><br/><br/></li>
						<li><a href="#">Label 1</a></li>
						<li><a href="#">Label 2</a></li>  -->
					</ul>
					
					<ul class="pull-right conversationsUser conversations col-md-10">
						<li class="loading" id="loading">
							<img src="${pageContext.request.contextPath}/resources/img/ajax-loader.gif" alt="Loader" />
						</li>				
					</ul>
								
				</div>
				<div class="status col-md-11"></div>
			</div>
		</sec:authorize>
		
		<jsp:include page="includes/popupEmail.jsp"></jsp:include>
		<jsp:include page="includes/commonFooter.jsp"></jsp:include>
		
		<script>
		
		$.ajax({
            url: "/dost/api/users",
            dataType: "json",
            success: function(data) {
            	console.log(1) ;
            	var arr =  $.map(data, function(users) {
                  return {
                    label: users.username,
                    name: users.userId,
                    };
                });   
            	console.log( arr ) ;	
            	$("#recipient" ).autocomplete({
        			source: arr,
        			minLength: 0,
        			select: function( event, ui ) {
        				console.log( ui ) ;
        				$("#recipient").val( ui.item.label ) ;
        				$("#selected_recipient").val( ui.item.name ) ;
        			}
            	});            	
            	
                }
            });
		
		/*end of populating users*/
		
		</script>
		
		
	</body>
</html>

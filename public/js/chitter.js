$(document).ready(function(){
	$("#user_sign_up").hide();
	$("#user_sign_in").hide();
	$('#notice').hide();
	$('#user_new_peep').hide();

	loadPage();
	
	$("#form_user_sign_in").validate();
	formNewPeep();
});

function updateUserInfo(user){
	if(jQuery.isEmptyObject(user)){
		replaceTemplate('#template_signed_out', '#user-buttons', user);
		$('#sign-up').on('click', function(){
			$('#form_user_sign_up')[0].reset();
			$("#user_sign_up").show();
			$("#user_sign_in").hide();
			$("#user-peeps").hide();
			$('#user_new_peep').hide();
		});

		//button sign-in
		$('#sign-in').on('click', function(){
			$('#form_user_sign_in')[0].reset();
			$("#user_sign_in").show();
			$("#user_sign_up").hide();
			$("#user-peeps").hide();
			$('#user_new_peep').hide();
		});

		formSignIn();
		formSignUp();
	}
	else
	{
		replaceTemplate('#template_signed_in', '#user-buttons', user);
		buttonSignOut();
		$('#new_peep').on('click', function(){
			$('#form_new_peep')[0].reset();
			$("#user_sign_in").hide();
			$("#user_sign_up").hide();
			$("#user-peeps").hide();
			$('#user_new_peep').show();
		});

		//formNewPeep();
	}
};

function updateListOfPeeps(peeps){ 
	replaceTemplate('#template_list_peeps', "#ul-peeps", peeps);
	updateButtonReply(peeps.user);
	$("#user-peeps").show();
};

function updateButtonReply(currentUser){
	if(!jQuery.isEmptyObject(currentUser))
	{
		replaceTemplate('#template_button-reply', '.button-reply', currentUser);
		$('.button-reply').show();
		$('.button-reply a').on("click", function(){
			//make something here :)
		});
	}
};

function buttonSignOut(){
	$('#sign_out').on('click', function() {
		$.ajax({
	      url: '/api/sessions/logout',
	      dataType: 'json',
	      contentType: 'application/json',
	      type: 'POST',
	      data : JSON.stringify({}),
	      accepts: "application/json",
	      success: function(message) {
	      	$("#notice").empty();
      		appendTemplate("#template_notice", '#notice', message);
        	$('#notice').show();
	        	setTimeout(function() {
	        		$('#notice').hide();
	        		loadPage();
					  }, 2000);
	      }
		});
	});
}

function formSignIn(){
	$("#form_user_sign_in").submit(function( event ) {
		event.preventDefault();
		var $form = $( this ), 
				email = $form.find( "input[name='email']" ).val(), 
				password = $form.find( "input[name='password']").val(),
				url = $form.attr( "action" );
		var data = JSON.stringify({ "email":  email, "password": password });
		sendUserAjaxRequest(url, data);
	});
}

function formSignUp(){
	$("#form_user_sign_up").submit(function( event ) {
			event.preventDefault();
			var $form = $( this ), 
					email = $form.find( "input[name='email']" ).val(), 
					username = $form.find( "input[name='username']" ).val(),
					name = $form.find( "input[name='name']" ).val(),
					password = $form.find( "input[name='password']").val(),
					password_confirmation = $form.find( "input[name='password_confirmation']").val(),
					url = $form.attr( "action" );
			var data = JSON.stringify({ "email":  email, 
	      												"username" : username,
	      												"name" : name,
	      												"password": password,
	      												"password_confirmation" : password_confirmation });
			sendUserAjaxRequest(url, data);
		});
}

function formNewPeep(){
	$("#form_new_peep").submit(function(event) {
		event.preventDefault();

		var $form = $(this), 
				peep_text = $form.find("textarea[name='message']").val(),
				url = $form.attr( "action" );

		var data = JSON.stringify({"message" : peep_text});
		
		$.ajax({
	    url: url,
	    dataType: 'json',
	    contentType: 'application/json',
	    type: 'POST',
	    data : data,
	    accepts: "application/json",
	    success:function(){
	    	console.log("success")
	    	loadPage();
	    }
    });	
	});
}

function sendUserAjaxRequest(url, data){
	$.ajax({
    url: url,
    dataType: 'json',
    contentType: 'application/json',
    type: 'POST',
    data : data,
    accepts: "application/json",
    success: function(user) {
    	if(!jQuery.isEmptyObject(user)){
    		console.log(user);
				replaceTemplate('#template_signed_in', '#user-buttons', user);
	      $("#user_sign_up").hide();
				$("#user_sign_in").hide();
				buttonSignOut();
				loadPage();
			}
			else {
					var message = {"message": "The email or password is incorrect."};
					$('#errors').empty();
					appendTemplate('#template_error', '#errors', message);
					setTimeout(function() {
	        		$('#errors').hide();
					  }, 2000);
			}
    }
	});	
}

function appendTemplate(templateName, element, dataSource){
	var source = $(templateName).html();
	var template = Handlebars.compile(source);
	$(element).append(template(dataSource));
}

function replaceTemplate(templateName, element, dataSource){
	var source = $(templateName).html();
	var template = Handlebars.compile(source);
	$(element).replaceWith(template(dataSource));
}

function loadPage(){
	$.getJSON("/api/", function(chitterData){
		updateUserInfo(chitterData.user);
		updateListOfPeeps(chitterData);
	});
}

Handlebars.registerHelper("formatDate", function(datetime) {
	if (moment) {
		return moment(datetime).format("DD/MM/YYYY HH:mm");
	}
	else {
		return datetime;
	}
});


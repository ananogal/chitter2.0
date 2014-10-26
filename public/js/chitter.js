$(document).ready(function(){
	$("#user_sign_up").hide();
	$("#user_sign_in").hide();
	$('#notice').hide();

	loadPage();
});

function updateUserInfo(user){
	if(jQuery.isEmptyObject(user)){
		replaceTemplate('#template_signed_out', '#user-buttons', user);
		$('#sign-up').on('click', function(){
			$('#form_user_sign_up')[0].reset();
			$("#user_sign_up").show();
			$("#user_sign_in").hide();
			$("#user-peeps").hide();
		});

		//button sign-in
		$('#sign-in').on('click', function(){
			$('#form_user_sign_in')[0].reset();
			$("#user_sign_in").show();
			$("#user_sign_up").hide();
			$("#user-peeps").hide();
		});
		formSignIn();
	}
	else
	{
		replaceTemplate('#template_signed_in', '#user-buttons', user);
		buttonSignOut();
	}
};

function updateListOfPeeps(peeps){ 
	appendTemplate('#template_list_peeps', "#ul-peeps", peeps);
	updateButtonReply(peeps.user);
	$("#user-peeps").show();
};

function updateButtonReply(currentUser){
	if(!jQuery.isEmptyObject(currentUser))
	{
		appendTemplate('#template_button-reply', '.button-reply', currentUser);
		$('.button-reply').show();
		$('.button-reply a').on("click", function(){
			//make something here :)
		});
	}
};

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
      		appendTemplate("#template_notice", '#notice', message);
        	$('#notice').show();
        	setTimeout(function() {
        		$('#notice').hide();
				  }, 2000);
        	loadPage();
	      }
		});
	});
}

function formSignIn(){
	$("#form_user_sign_in" ).submit(function( event ) {
		event.preventDefault();
		var $form = $( this ), email = $form.find( "input[name='email']" ).val(), 
								url = $form.attr( "action" ), password = $form.find( "input[name='password']").val();
		$.ajax({
	      url: url,
	      dataType: 'json',
	      contentType: 'application/json',
	      type: 'POST',
	      data : JSON.stringify({ "email":  email, "password": password }),
	      accepts: "application/json",
	      success: function(user) {
					replaceTemplate('#template_signed_in', '#user-buttons', user);
	        $("#user_sign_up").hide();
					$("#user_sign_in").hide();
					buttonSignOut();
					loadPage();
	      }
		});
	});
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


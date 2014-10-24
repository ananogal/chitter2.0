$(document).ready(function(){
	$("#user_sign_in").hide();
	$.getJSON("/api/", function(chitterData){
		// $('#template_signed_in').append(template(chitterData));
		console.log(chitterData);
		var user = chitterData.user;
		if(jQuery.isEmptyObject(user)){
			var source = $('#template_signed_out').html();
			var template = Handlebars.compile(source);
			$('#user-buttons').append(template());
		}
		else
			{
				var source = $('#template_signed_in').html();
				var template = Handlebars.compile(source);
				$('#user-buttons').append(template(user));
			}
	});
});

$(document).ready(function(){
	$("#user_sign_in").hide();
	view = new ChitterView();
	$.getJSON("/api/", function(chitterData){
		view.updateUserInfo(chitterData.user);
		view.updateListOfPeeps(chitterData.peeps, chitterData.user);
	});
});

function ChitterView(){}

ChitterView.prototype.updateUserInfo = function(user){
	if(jQuery.isEmptyObject(user)){
			var source = $('#template_signed_out').html();
			var template = Handlebars.compile(source);
			$('#user-buttons').append(template());
			$('#sign-in').on('click', function(){
				
			});
		}
		else
		{
			var source = $('#template_signed_in').html();
			var template = Handlebars.compile(source);
			$('#user-buttons').append(template(user));
		}
};

ChitterView.prototype.updateListOfPeeps = function(peeps, currentUser) {
	$.each(peeps, function(index, peep){
		var source = $('#template_list_peeps').html();
		var template = Handlebars.compile(source);
		$("#ul-peeps").append(template(peep));
		
		updateButtonReply(currentUser);
		updatePeepUser(peep.user_id, "#user-info");
		updateReplies(peep);	
	});
};

 function updateButtonReply(currentUser){
	if(!jQuery.isEmptyObject(currentUser))
	{
		var source = $('#template_button-reply').html();
		var template = Handlebars.compile(source);
		$('.button_reply').append(template(currentUser));
		$('.button_reply a').on("click", function(){
			//make something here :)
		});
	}
};

function updatePeepUser(user_id, elementToUpdate){
	$.getJSON('/api/users/'+user_id, function(user){
			var source = $('#template_peep-user-info').html();
			var template = Handlebars.compile(source);
			$(elementToUpdate).replaceWith(template(user));
	});
};

function updateReplies(peep){
	$.getJSON('/api/repies/' + peep.id, function(repliesData){
		$.each(repliesData, function(index, reply){
			$.getJSON('/api/peeps/'+reply.answer_id, function(answer){
					var source = $('#template_replies').html();
					var template = Handlebars.compile(source);
					$("#replies"+peep.id).append(template(answer));
					updatePeepUser(answer.user_id, "#reply-user-info");
			});
			
		});
	});
};


Handlebars.registerHelper("formatDate", function(datetime) {
	if (moment) {
		return moment(datetime).format("DD/MM/YYYY HH:mm");
	}
	else {
		return datetime;
	}
});


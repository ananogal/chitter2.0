
get '/users/new' do
	erb :"users/new"
end

post '/users' do
	@user = User.create(:email => params[:email], 
						:username => params[:username],
						:name => params[:name],
						:password =>params[:password],
						:password_confirmation =>params[:password_confirmation])

	if @user.save
		session[:user_id] = @user.id
		redirect to'/'
	else
		flash.now[:errors] = @user.errors.full_messages	
		erb :"users/new"
	end
end
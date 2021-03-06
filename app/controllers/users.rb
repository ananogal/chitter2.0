
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

get '/users/forgotten' do
	erb :"users/forgotten"
end

post '/users/forgotten' do
	@user = User.first(:email => params[:email])
	if @user
		@user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
        @user.password_token_timestamp = Time.now
        @user.save
        send_message(@user)
        flash[:notice] = "We've just send you an email confirmation."
	else
		flash.now[:errors] = ["The email you enter is not correct."]
	end
	erb :"users/forgotten"
end

get '/users/reset_password/:token' do
	@token = params[:token]
	@user = User.first(:password_token => @token)
	if !@user
		flash.now[:errors] = ["This token is not valid."]
	elsif @user.password_token_timestamp + 60*60 < Time.now
		flash.now[:errors] = ["This token is not valid anymore."]
	end
	@token = @user ? @user.password_token : ""  
	erb :"users/reset_password"
end

post '/users/reset_password' do
	@password = params[:password]
	@password_confirmation = params[:password_confirmation]
	@token = params[:token]
	@user = User.first(:password_token => @token)
	@user.password = @password
	@user.password_confirmation = @password_confirmation
	
	if @user.save
		session[:user_id] = @user.id
		redirect to'/'
	else
		flash.now[:errors] = ["Password does not match the confirmation"]
		erb :"users/reset_password"
	end
end










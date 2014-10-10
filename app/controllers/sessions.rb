
get '/sessions/new'do
	erb :new
end 

delete '/sessions' do
  flash[:notice] = "Good bye!"
  session[:user_id] = nil
  redirect to('/')
end
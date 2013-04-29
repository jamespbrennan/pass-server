class SessionsController < ApplicationController

	def new
		api_token = ApiToken.find_by(token: PassServer::Application.config.api_token)

		if api_token
    	service = api_token.api_consumer
			session = Session.create(service_id: service.id)
			@pass_session_id = session.id
		else
			@pass_session_id = 0
		end
	end
	
	def create

		begin
			params.required(:email)
			params.required(:password)
		rescue
			flash.now.alert = "Both email and password are required."
			return render "new"
		end

		user = User.find_by_email(params[:email])

		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect_to root_url
		else
			flash.now.alert = "Email and password combination is invalid."
			render "new"
		end
	end

	def callback
		params.required(:id)

		session = Session.find(params[:id])

	end
	
	def destroy
		reset_session
		redirect_to root_url
	end
end

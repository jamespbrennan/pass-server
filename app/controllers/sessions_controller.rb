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
			flash.now.alert = 'Both email and password are required.'
			return render 'new'
		end

		user = User.find_by_email(params[:email])

		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect_to root_url
		else
			flash.now.alert = 'Email and password combination is invalid.'
			render 'new'
		end
	end

	def callback
		params.required('session_id')

    pass_session = Session.find params[:session_id]

    if pass_session.is_authenticated && pass_session.user
      session = ActiveRecord::SessionStore::Session.find_by_pass_session_id(pass_session.id)
      session.set_attribute!('pass_user_id', pass_session.user.id)
      session.save
    else
      logger.error 'Receieved a unauthenticated session.'
      logger.error pass_session.to_s
    end

    render nothing: true
	end
	
	def destroy
		reset_session
		redirect_to root_url
	end
end

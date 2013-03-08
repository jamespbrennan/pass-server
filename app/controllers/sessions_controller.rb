class SessionsController < ApplicationController
	def new
	end
	
	def create
		params.required(:email)
		params.required(:password)

		user = User.find_by_email(params[:email])

		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect_to root_url, notice: "Logged in!"
		else
			flash.now.alert = "Email/password combination is invalid."
			render "new"
		end
	end
	
	def destroy
		reset_session
		redirect_to root_url, notice: "Logged out!"
	end
end

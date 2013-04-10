class SessionsController < ApplicationController

	def new
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
	
	def destroy
		reset_session
		redirect_to root_url
	end
end

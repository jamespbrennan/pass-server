module V1
	class UsersController < ApiController
		respond_to :json

		# 
		# Create a user
		#
		# Required parameters:
		# => email
		# => password
		#
		# Returns:
		# => id
		# => email
		# => device_id
		# => created_at
		#

		def create
			params.required(:email)
			params.required(:password)

			User.create(:email => params[:email], :password => params[:password])
			error_check
		end

		private

		#
		# Check for active record errors. Set status header to 500 and display errors as JSON 
		# if any are found.
		#

		def error_check
			render :json => {
			  :errors => {
				:message => @device.errors.full_messages,
				:code => 500
			  }
			}.to_json, :status => :error if ! @device.valid?
		end

		#
		# Show a 404 error on an ActiveRecord::RecordNotFound exception.
		#

		def record_not_found
			render :json => {
			  :errors => {
				:message => "Sorry, couldn't find that device.",
				:code => 404
			  }
			}.to_json, :status => :not_found
		end
	end
end
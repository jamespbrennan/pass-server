module V1
	class UsersController < ApiController
		respond_to :json

		# == Create a user
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

			@user = User.create(:email => params[:email], :password => params[:password])

			invalid_request_error_check
		end

		private

		# == Error check
		#
		# Check for active record errors. Set status header to 500 and display errors as JSON 
		# if any are found.
		#

		def api_error_check(record = @user)
			super record
		end

		def invalid_request_error_check(record = @user)
			super record
		end

	end
end
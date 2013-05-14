module Api
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
			# => created_at
			#

			def create
				params.required(:email)
				params.required(:password)

				@user = User.create(:email => params[:email], :password => params[:password])

				invalid_request_error_check
			end

			# == Get a user
			#
			# Required parameters:
			# => id
			#
			# Returns:
			# => id
			# => email
			#

			def get
				params.required(:id)	

				# Grab the service that is trying to authenticate
        unathenticated_error unless @api_consumer.is_a? Service
        service = @api_consumer

				@user = service.users.find params[:id]
			end

			# == Destroy a user
			#
			# Required parameters:
			# => email
			# => password
			#
			# Returns nothing
			#

			def destroy
				params.required(:email)
        params.required(:password)

        # Authenticate the user
        begin
          user = User.find_by(email: params[:email])

          raise ActiveRecord::RecordNotFound unless user && user.authenticate(params[:password])
        rescue ActiveRecord::RecordNotFound
          return handle_error('Invalid email and password combination.', 'invalid_request_error', 401);
        end

        user.destroy

        render nothing: true
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
end
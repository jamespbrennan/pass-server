include 
module V1
	class ProversController < ApiController
		respond_to :json

		# 
		# Create a prover 
		#
		# Required parameters:
		# => email
		# => password
		# Optional parameters:
		# => name
		# => device_identifier
		#
		# Returns:
		# => id
		# => name
		# => access_token
		# => created_at
		#

		def create
			params.required(:email)
			params.required(:password)
			params.permit(:name)
			params.permit(:device_identifier)

			# Authenticate the user
			user = User.find_by_email(params[:email])

			if ! user && user.authenticate(params[:password])
				return render :json => {
					:errors => {
						:message => "Invalid email and password combination.",
						:code => 401
					}
				}.to_json, :status => :unauthorized
			end

			@prover = Prover.new

			# Attach a device type to the prover
			if params[:device_identifier]
				device_type = DeviceTypes.find_by_identifier(params[:device_identifier])

				# If no device type is found, get the `Unknown` device type
				if device_type.nil?
					device_type = DeviceTypes.find_by_identifier('')
				end
			else
				device_type = DeviceTypes.find_by_identifier('')
			end

			@prover.device_type_id = (defined? device.id) ? device.id : nil

			@prover.user_id = user.id
			@prover.name = (defined? params[:name]) ? params[:name] : nil
			
			@prover.save

			error_check
		end

		#
		# Register a prover to a service.
		#
		# Reqired parameters:
		# => prover_id
		# => service_id
		# => public_key
		# => signature = hmac_sha1(prover.auth_token, <prover_id>:<service_id>:<public_key>)
		#
		# Returns:
		# => prover_id
		# => service_id
		# => created_at
		#

		def register
			attributes = params.required(:prover_id).required(:service_id).required(:public_key)
			params.required(:signature)

			# Make sure the prover exists
			prover = Prover.find(:prover_id)

			if ! prover.nil?
				return render :json => {
					:errors => {
						:message => "Unable to find prover for given prover id.",
						:code => 404
					}
				}.to_json, :status => :not_found
			end

			# Make sure the given signature is valid
			message = attributes.map{|k,v| "#{v}"}.join(":")

			if ! verify_signature(prover.auth_token, message, params[:signature])
				return render :json => {
					:errors => {
						:message => "Invalid signature.",
						:code => 401
					}
				}.to_json, :status => :unauthorized
			end

			# Check the public key
			begin
				# Create an RSA object from the prover's public key to test if it is valid
				public_key = OpenSSL::PKey::RSA.new params[:public_key]
			rescue OpenSSL::PKey::RSAError
				return render :json => {
				  :errors => {
					:message => "The public key you provided is not a valid public key.",
					:code => 500
				  }
				}.to_json, :status => :error
			end

			# Make sure the key is actually a pulic key, and not private
			if ! public_key.public?
				return render :json => {
				  :errors => {
					:message => "The public key you provided is not a valid public key.",
					:code => 500
				  }
				}.to_json, :status => :error
			end

			ProverAccount.create(attributes)

			error_check_prover_account
		end

		private

		#
		# Check for active record errors. Set status header to 500 and display errors as JSON 
		# if any are found.
		#

		def error_check
			render :json => {
			  :errors => {
				:message => @prover.errors.full_messages,
				:code => 500
			  }
			}.to_json, :status => :error if ! @prover.valid?
		end

		#
		# Check for active record errors. Set status header to 500 and display errors as JSON 
		# if any are found.
		#

		def error_check_prover_account
			render :json => {
			  :errors => {
				:message => @prover_account.errors.full_messages,
				:code => 500
			  }
			}.to_json, :status => :error if ! @prover_account.valid?
		end

		#
		# Show a 404 error on an ActiveRecord::RecordNotFound exception.
		#

		def record_not_found
			render :json => {
			  :errors => {
				:message => "Sorry, couldn't find that prover.",
				:code => 404
			  }
			}.to_json, :status => :not_found
		end
	end
end
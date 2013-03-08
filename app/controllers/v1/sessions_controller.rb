module V1
	class SessionsController < ApiController
		respond_to :json

		#
		# Create a session.
		#
		# Required parameters:
		# => service_id
		#
		# Returns:
		# => id
		# => service_id
		# => token
		# => created_at
		#

		def create
			params.required(:service_id)

			@session = Session.create(:service_id => params[:service_id])

			error_check
		end

		def get
			params.required(:id)
			params.permit(:prover_id)

			@session = Session.find(params[:id])

			@session.prover_id = params[:prover_id]
			@session.save

			error_check
		end

		#
		# Authenticate a prover
		#
		# Requred parameters:
		# => prover_id
		# => session_id
		# => token
		#

		def authenticate
			params.required(:prover_id)
			params.required(:session_id)
			params.required(:token)

			session = Session.find(params[:session_id])

			if session.nil?
				return record_not_found
			end

			# Make sure the prover belongs to the session
			if session.prover_id != params[:prover_id]
				return render :json => {
					:errors => {
						:message => "Prover does not match the session.",
						:code => 500
					}
				}.to_json, :status => :error
			end

			prover = Prover.find(params[:prover_id])

			if prover.nil?
				return render :json => {
					:errors => {
						:message => "Unable to find the prover specified.",
						:code => 500
					}
				}.to_json, :status => :error
			end

			begin
				# Create an RSA object from the prover's public key
				public_key = OpenSSL::PKey::RSA.new prover.public_key
			rescue OpenSSL::PKey::RSAError
				render :json => {
				  :errors => {
					:message => "A public key is not available for the prover.",
					:code => 500
				  }
				}.to_json, :status => :error
				return
			end
			
			# Decrypt the provided token with the prover's public key
			plaintext_token = public_key.public_decrypt Base64::decode64(params[:token])

			if plaintext_token != session.token
				# Unsuccessful authentication
				render :json => {
				  :errors => {
					:message => "Unsuccessful authentication.",
					:code => 401
				  }
				}.to_json, :status => 401
				return
			end
		end

		private

		#
		# Check for active record errors. Set status header to 500 and display errors as JSON 
		# if any are found.
		#

		def error_check
			render :json => {
				:errors => {
					:message => @session.errors.full_messages,
					:code => 500
				}
			}.to_json, :status => :error if ! @session.valid?
		end

		#
		# Show a 404 error on an ActiveRecord::RecordNotFound exception.
		#

		def record_not_found
			render :json => {
				:errors => {
					:message => "Sorry, couldn't find that session.",
					:code => 404
				}
			}.to_json, :status => :not_found
		end
	end
end

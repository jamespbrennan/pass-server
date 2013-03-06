module V1
	class SessionsController < ApiController
		respond_to :json

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

		def authenticate
			params.required(:prover_id)
			params.required(:session_id)
			params.required(:token)

			session = Session.find(params[:session_id])

			# Make sure the prover belongs to the session
			if session.prover_id != params[:prover_id]
				render :json => {
				  :errors => {
					:message => "Prover does not match the session.",
					:code => 500
				  }
				}.to_json, :status => :error
				return
			end

			prover = Prover.find(params[:prover_id])

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

		def error_check
			render :json => {
			  :errors => {
				:message => @session.errors.full_messages,
				:code => 500
			  }
			}.to_json, :status => :error if ! @session.valid?
		end

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
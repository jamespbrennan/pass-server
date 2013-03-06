module V1
	class SessionsController < ApiController
		respond_to :json

		def create
			params.required(:user_id)
			params.required(:public_key)
			params.permit(:name)
			params.permit(:device_type_id)

			# Check the public key
			begin
				# Create an RSA object from the prover's public key
				public_key = OpenSSL::PKey::RSA.new prover.public_key
			rescue OpenSSL::PKey::RSAError
				render :json => {
				  :errors => {
					:message => "The public key you provided is not a valid public key.",
					:code => 500
				  }
				}.to_json, :status => :error
				return
			end

			if ! public_key.public?
				render :json => {
				  :errors => {
					:message => "The public key you provided is not a valid public key.",
					:code => 500
				  }
				}.to_json, :status => :error
				return
			end

			@prover = Prover.create
			@prover.user_id = params[:user_id]
			@prover.name = params[:name]
			@prover.device_type_id = params[:device_type_id]
			@prover.public_key = params[:public_key]
			@prover.save

			error_check
		end

		private

		def error_check
			render :json => {
			  :errors => {
				:message => @prover.errors.full_messages,
				:code => 500
			  }
			}.to_json, :status => :error if defined? @prover.errors
		end

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
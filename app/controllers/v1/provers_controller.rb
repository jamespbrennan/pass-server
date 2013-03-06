module V1
	class ProversController < ApiController
		respond_to :json

		def create
			params.required(:user_id)
			params.permit(:name)
			params.permit(:device_identifier)

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

			@prover.user_id = params[:user_id]
			@prover.name = (defined? params[:name]) ? params[:name] : nil
			
			@prover.save

			error_check
		end

		def register
			attributes = params.required(:prover_id).required(:service_id).required(:public_key)

			# Check the public key
			begin
				# Create an RSA object from the prover's public key to test if it is valid
				public_key = OpenSSL::PKey::RSA.new params[:public_key]
			rescue OpenSSL::PKey::RSAError
				render :json => {
				  :errors => {
					:message => "The public key you provided is not a valid public key.",
					:code => 500
				  }
				}.to_json, :status => :error
				return
			end

			# Make sure the key is actually a pulic key, and not private
			if ! public_key.public?
				render :json => {
				  :errors => {
					:message => "The public key you provided is not a valid public key.",
					:code => 500
				  }
				}.to_json, :status => :error
				return
			end

			@prover.create(attributes)

			error_check_prover_account
		end

		private

		def error_check
			render :json => {
			  :errors => {
				:message => @prover.errors.full_messages,
				:code => 500
			  }
			}.to_json, :status => :error if ! @prover.valid?
		end

		def error_check_prover_account
			render :json => {
			  :errors => {
				:message => @prover_account.errors.full_messages,
				:code => 500
			  }
			}.to_json, :status => :error if ! @prover_account.valid?
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
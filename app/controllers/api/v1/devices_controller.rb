module Api
  module V1
    class DevicesController < ApiController
      respond_to :json

      # == Create a device 
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
      # => token
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
          # Don't send the plaintext password back to the remote client
          params.delete :password

          return error('Invalid email and password combination.', 'invalid_request_error', 401);
        end

        @device = Device.new

        # Attach a device type to the device
        if params[:device_identifier]
          device_type = DeviceTypes.find_by_identifier(params[:device_identifier])

          # If no device type is found, get the `Unknown` device type
          if device_type.nil?
            device_type = DeviceTypes.find_by_identifier('')
          end
        else
          device_type = DeviceTypes.find_by_identifier('')
        end

        @device.device_type_id = (defined? device.id) ? device.id : nil

        @device.user_id = user.id
        @device.name = (defined? params[:name]) ? params[:name] : nil
        
        @device.save

        invalid_request_error_check
      end

      # == Register a device to a service.
      #
      # Reqired parameters:
      # => device_id
      # => service_id
      # => public_key
      # => signature = hmac_sha1(device.auth_token, <device_id>:<service_id>:<public_key>)
      #
      # Returns:
      # => device_id
      # => service_id
      # => created_at
      #

      def register
        attributes = params.required(:device_id).required(:service_id).required(:public_key)
        params.required(:signature)

        # Make sure the device exists
        device = Device.find(:device_id)

        # Make sure the given signature is valid
        message = attributes.map{|k,v| "#{v}"}.join(":")

        if ! verify_signature(device.auth_token, message, params[:signature])
          return error("Invalid signature: '#{params[:signature]}'.", 'invalid_request_error', 401)
        end

        # Check the public key
        begin
          # Create an RSA object from the device's public key to test if it is valid
          public_key = OpenSSL::PKey::RSA.new params[:public_key]
        rescue OpenSSL::PKey::RSAError
          return error('The public key you provided is not a valid public key.')
        end

        # Make sure the key is actually a pulic key, and not private
        if ! public_key.public?
          return error('The public key you provided is not a valid public key.')
        end
        
        device_account = DeviceAccount.create(attributes)

        # Using remote client provided data, so check it for errors
        invalid_request_error_check(device_account)
      end

      private

      # == Error Check
      #
      # Check for active record errors. Set status header to 500 and display errors as JSON 
      # if any are found.
      #

      def api_error_check(record = @device)
        super record
      end

      def invalid_request_error_check(record = @device)
        super record
      end

    end
  end
end
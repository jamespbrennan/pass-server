module Api
  module V1
    class DevicesController < ApiController

      before_action :restrict_access, except: :create

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
        begin
          user = User.find_by(email: params[:email])

          raise ActiveRecord::RecordNotFound unless user && user.authenticate(params[:password])
        rescue ActiveRecord::RecordNotFound, Exception
          return handle_error('Invalid email and password combination.', 'invalid_request_error', 401);
        end

        @device = Device.new

        # Attach a device type to the device
        if defined? params[:device_identifier]
          begin
            device_type = DeviceType.find_by(identifier: params[:device_identifier])
          rescue ActiveRecord::RecordNotFound
            # If no device type is found, get the `Unknown` device type
            device_type = DeviceType.find_by(identifier: '')
          end
        else
          device_type = DeviceType.find_by(identifier: '')
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
      # => service_id
      # => public_key
      #
      # Returns:
      # => device_id
      # => service_id
      # => created_at
      #

      def register
        attributes = params.required(:service_id).required(:public_key)

        # Make sure the token is a valid device token
        unathenticated_error if ! @api_consumer.is_a? Device
        device = @api_consumer

        # Check the public key
        begin
          # Create an RSA object from the device's public key to test if it is valid
          public_key = OpenSSL::PKey::RSA.new params[:public_key]

           # Make sure the key is actually a pulic key, and not private
          raise Exception unless public_key.public?
        rescue OpenSSL::PKey::RSAError, Exception
          return handle_error('The public key you provided is not a valid public key.')
        end
        
        device_account = DeviceAccount.new(attributes)
        device_account.device = device
        device_account.save

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
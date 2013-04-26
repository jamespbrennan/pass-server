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
        params.required(:name)
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

        @device.device_type_id = (defined? device_type.id) ? device_type.id : nil

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
        params.required(:service_id)
        params.required(:public_key)

        # Make sure the token is a valid device token
        unathenticated_error unless @api_consumer.is_a? Device
        device = @api_consumer
        
        @device_account = DeviceAccount.create(service_id: params[:service_id], public_key: params[:public_key], device_id: device_id)

        # Using remote client provided data, so check it for errors
        invalid_request_error_check(@device_account)
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
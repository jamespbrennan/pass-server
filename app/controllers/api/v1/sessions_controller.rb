module Api
  module V1
    class SessionsController < ApiController

      before_action :restrict_access, except: :authenticate

      respond_to :json

      # == Create a session.
      #
      # Returns:
      # => id
      # => service_id
      # => created_at
      #

      def create
        unathenticated_error if ! @api_consumer.is_a? Service
        service = @api_consumer

        @session = Session.create(service_id: service.id)

        invalid_request_error_check
      end

      # == Get a session
      #
      # Returns:
      # => id
      # => service_id
      # => is_authenticated
      # => user
      #   => id
      #   => email 
      #

      def get
        params.required(:id)

        # Grab the device that is trying to authenticate
        unathenticated_error if ! @api_consumer.is_a? Service
        service = @api_consumer

        @session = service.sessions.find(params[:id])
      end

      # == Get a session
      #
      # Required parameters:
      # => id
      #
      # Returns login QR code HTML
      #

      def authenticate
        params.required(:id)

        @session = Session.find(params[:id])

        # Update the session with the browser's IP address
        @session.remote_ip_address = request.remote_ip
        @session.save

        api_error_check && return

        # Allow the iframe to be embedded in the services' domain
        response.headers["X-Frame-Options"] = "ALLOW-FROM " + @session.service.url
      end

      # == Authenticate a device
      #
      # Requred parameters:
      # => id
      # => token
      #

      def do_authentication
        params.required(:id)
        params.required(:token)

        # Grab the device that is trying to authenticate
        unathenticated_error if ! @api_consumer.is_a? Device
        device = @api_consumer

        @session = Session.find(params[:id])

        # Get the account for that device/service
        device_account = device.device_accounts(@session.service_id).first

        # Add the device's IP address to the session, regardless if the authentication is sucessful or not
        @session.device_ip_address = request.remote_ip
        @session.device = device

        if device_account
          begin
            # Create an verify key from the device's public key
            raise unless (verify_key = Crypto::VerifyKey.new(device_account.public_key, :hex))
          rescue
            return handle_error('A public key is not available for the device.', 'api_error', 500)
          end
          
          begin
            # Verify the provided token with the device's public key
            @session.is_authenticated = verify_key.verify(@session.token, params[:token], :hex)
          rescue
            # Unsuccessful authentication
            handle_error("Unsuccessful authentication. #{@session.is_authenticated}", 'invalid_request_error', 401)
          end
        else
          handle_error('There is no account for this device with this service. You must register the device first to the service before authenticating.')
        end

        # Make sure we didn't mess up
        api_error_check && return

        @session.save
      end

      private

      # == Error Check
      #
      # Check for active record errors. Set status header to 500 and display errors as JSON 
      # if any are found.
      #

      def api_error_check(record = @session)
        super record
      end

      def invalid_request_error_check(record = @session)
        super record
      end

    end
  end
end
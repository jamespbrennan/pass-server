module Api
  module V1
    class SessionsController < ApiController
      respond_to :json

      # == Create a session.
      #
      # Required parameters:
      # => service_id
      #
      # Returns:
      # => id
      # => service_id
      # => created_at
      #

      def create
        params.required(:service_id)

        @session = Session.create(:service_id => params[:service_id])

        invalid_request_error_check
      end

      # == Get a session
      #
      # Required parameters:
      # => id
      #
      # Returns login QR code HTML
      #

      def get
        params.required(:id)

        @session = Session.find(params[:id])

        # Update the session with the browser's IP address
        @session.remote_ip_address = request.remote_ip
        @session.save

        api_error_check

        # Allow the iframe to be embedded in the services' domain
        response.headers["X-Frame-Options"] = "ALLOW-FROM " + @session.service.url
      end

      # == Authenticate a device
      #
      # Requred parameters:
      # => device_id
      # => session_id
      # => token
      #

      def authenticate
        params.required(:device_id)
        params.required(:session_id)
        params.required(:token)

        session = Session.find(params[:session_id])

        # Grab the device that is trying to authenticate
        device = Device.find(params[:device_id])

        # Add the device's IP address to the session, regardless if the authentication is sucessful or not
        session.device_ip_address = request.remote_ip
        session.device_id = device

        # Make sure we didn't mess up
        api_error_check(session) && return

        session.save

        begin
          # Create an RSA object from the device's public key
          public_key = OpenSSL::PKey::RSA.new device.public_key
        rescue OpenSSL::PKey::RSAError
          return error('A public key is not available for the device.', 'api_error', 500)
        end
        
        # Decrypt the provided token with the device's public key
        plaintext_token = public_key.public_decrypt Base64::decode64(params[:token])

        if plaintext_token != session.token
          # Unsuccessful authentication
          return error('Unsuccessful authentication.', 'invalid_request_error', 401)
        end
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
class ApiController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	# protect_from_forgery with: :null_session

	rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from ActionController::ParameterMissing, :with => :parameter_missing

	private

	# == Record Not Found
	#
	# Show a 404 error on an ActiveRecord::RecordNotFound exception.
	#
	
	def record_not_found(e)
    handle_error(e.to_s, 'invalid_request_error', 404)
	end

  # == Parameter Missing
  #
  # Show a 402 error on an ActionController::ParameterMissing exception.
  #
  
  def parameter_missing(e)
    #TODO Display an error message with all the required parameters, not just the one that triggered with exception.
    # This is not currently possible with strong_parameters. Check in with https://github.com/rails/strong_parameters/pull/117
    handle_error(e.to_s, 'invalid_request_error', 406)
  end

  # == API Error Check
  #
  # Check for active record errors. Set status header to 500 and display errors as JSON 
  # if any are found.
  #

  def api_error_check(record, status_code = 500)
    message = 'Sorry something went wrong, we\'re lookgin into it. Please retry you\'re request shortly'
    handle_error(message, 'api_error', status_code, false) if ! record.valid?
  end

  # == Invalid Request Error Check
  #
  # Check for active record errors. Set status header to 406 (typically) and display errors as JSON 
  # if any are found. Include any params provided by the remote client.
  #

  def invalid_request_error_check(record, status_code = 406)
    handle_error(record.errors.full_messages, 'invalid_request_error', status_code) unless record.valid?
  end

  # == Unathenticated Error
  #
  #

  def unauthenticated_error()
    handle_error('Unauthenticated. Please include your token in the Authorization header.', 'invalid_request_error', 401, false)
  end

  # == Error
  #
  # Display a JSON error
  #

  def handle_error(message, type = 'invalid_request_error', status_code = 402, include_params = true)
    response = {
      :error => {
        :type => type,
        :message => message,
        :code => status_code
      }
    }

    # If there were any params with the request, send them back to the user to aid in debugging
    response[:error][:params] = request.query_parameters if include_params && request.query_parameters.length > 0

    render :json => response.to_json, :status => status_code

    # There was an error
    true
  end

  # == Authenticate
  #
  # Authenticate with a HTTP Authorization header.
  #
  # Eg. curl https://api.domain.com/sesisons -H 'Authorization: Token token="12345"'
  #

  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      @api_consumer = ApiToken.find_by(token: token).api_consumer
    end

    !!@api_consumer
  end

end

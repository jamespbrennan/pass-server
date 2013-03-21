module V1
  class ErrorsController < ApiController
    def routing
      error('Resource not found.', 'invalid_request_error', 404)
    end
  end
end
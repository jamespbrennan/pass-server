module V1
  class ErrorsController < ApiController
    def routing
      render :json => {
        :errors => {
          :message => 'Resource not found.',
          :code => 404
        }
      }.to_json, :status => :not_found
    end
  end
end
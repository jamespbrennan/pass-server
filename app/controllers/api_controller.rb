class ApiController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	# protect_from_forgery with: :null_session

	rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

	private

	# == Record Not Found
	#
	# Show a 404 error on an ActiveRecord::RecordNotFound exception.
	#
	
	def record_not_found(e)
		render :json => {
			:errors => {
				:message => e.to_s,
				:code => 404
			}
		}.to_json, :status => :not_found
	end

	# == Error Check
    #
    # Check for active record errors. Set status header to 500 and display errors as JSON 
    # if any are found.
    #

    def error_check(record)
      render :json => {
        :errors => {
          :message => record.errors.full_messages,
          :code => 500
        }
      }.to_json, :status => :error if ! record.valid?
    end

end

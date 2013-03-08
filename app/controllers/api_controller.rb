class ApiController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	# protect_from_forgery with: :null_session

	rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

	private

	#
	# Show a 404 error on an ActiveRecord::RecordNotFound exception.
	#
	
	def record_not_found
		render :json => {
			:errors => {
				:message => "Sorry, couldn't find that record.",
				:code => 404
			}
		}.to_json, :status => :not_found
	end
end

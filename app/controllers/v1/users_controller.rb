module V1
	class UsersController < ApiController
		respond_to :json

		def create
			params.required(:email)
			params.required(:password)

			User.create(:email => params[:email], :password => params[:password])
			error_check
		end

		private

		def error_check
			render :json => {
			  :errors => {
				:message => @prover.errors.full_messages,
				:code => 500
			  }
			}.to_json, :status => :error if ! @prover.valid?
		end

		def record_not_found
			render :json => {
			  :errors => {
				:message => "Sorry, couldn't find that prover.",
				:code => 404
			  }
			}.to_json, :status => :not_found
		end
	end
end
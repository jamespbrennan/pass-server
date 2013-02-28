module V1
	class SessionsController < ApplicationController
		respond_to :json

		def create
			params.required(:service_id)

			@session = Session.create()
			@session.service_id = params[:service_id]
			@session.save
		end

		def get
			params.required(:id)
			params.permit(:prover_id)


			@session = Session.find(params[:id])

			@session.prover_id = params[:prover_id]
			@session.save
		end

		private

		def record_not_found
			render :json => {
				  :errors => {
				    :message => "Sorry, couldn't find that session.",
				    :code => 404
				  }
				}.to_json, :status => :not_found
		end
	end
end
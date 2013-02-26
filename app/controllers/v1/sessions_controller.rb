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
	end
end
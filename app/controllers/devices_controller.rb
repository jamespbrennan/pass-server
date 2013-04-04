class DevicesController < ApplicationController

	before_filter :authorize

	def index
		@devices = current_user.devices
	end

	def show
		@device = current_user.devices.find(params[:id])
	end

end

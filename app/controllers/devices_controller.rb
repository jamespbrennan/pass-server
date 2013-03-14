class DevicesController < ApplicationController

	before_filter :authorize

	def index
		@devices = current_user.devices.includes(:device_type)
	end
end

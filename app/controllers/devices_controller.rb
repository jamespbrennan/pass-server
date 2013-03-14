class DevicesController < ApplicationController

	before_filter :authorize

	def index
		@devices = nil
	end
end

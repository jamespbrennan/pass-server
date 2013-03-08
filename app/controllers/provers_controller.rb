class ProversController < ApplicationController

	before_filter :authorize

	def index
		@provers = nil
	end
end

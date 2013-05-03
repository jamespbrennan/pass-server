class DevicesController < ApplicationController

	before_filter :authorize

	def index
		@devices = current_user.devices
	end

	def show
		@device = current_user.devices.find(params[:id])
	end

  def logins
    @device_account = current_user.device_accounts.find(params[:id])
  end

  def destroy
    params.required(:id)

    Device.destroy(params[:id])

    redirect_to action: "index"
  end

end

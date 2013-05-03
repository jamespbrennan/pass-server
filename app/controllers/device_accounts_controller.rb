class DeviceAccountsController < ApplicationController
  def destroy
    params.required(:id)

    device_account = DeviceAccount.destroy params[:id]

    redirect_to device_path(device_account.device)
  end
end

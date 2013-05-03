class ServicesController < ApplicationController
  def index
    @services = @current_user.services
  end

  def show
    params.required(:id)

    @service = current_user.services.find params[:id]
  end

  def new
  end

  def create
    attributes = params.required(:service).permit(:name, :url, :allowed_ip_addresses)

    service = Service.create attributes

    DeveloperAccount.create(service: service, user: current_user, is_admin: true)
  end

  def update
    attributes = params.required(:service).permit(:name, :url, :allowed_ip_addresses)

    Service.update attributes
  end

  def destroy
    params.required(:id)

    Service.destroy params[:id]
  end
end

class DeviceAccountObserver < ActiveRecord::Observer
  
  def after_update(device_account)
    data = { id: device_account.user.id, email: device_account.user.email }.to_json

    #TODO Should this be done with delayed jobs? Will it get to the service in time? How slow is this for 2+ callbacks?
    # Tell the service of the user creation
    service = device_account.service
    callbacks = service.callbacks.all(conditions: { callback_type_id: CallbackType.find_by(name: 'user_creation') })

    callbacks.each do |callback|
      begin
        uri = URI.parse callback

        request = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
        request.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request.body = data
        response = Net::HTTP.new(uri.host, uri.port).start do |http|
          http.request(request)
        end
        
      rescue
        #TODO Notify service that the callback is bad, maybe create a delayed job? Probably too late for that
      end
    end if callbacks
  end
  
end

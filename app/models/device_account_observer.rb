class DeviceAccountObserver < ActiveRecord::Observer
  
  def after_create(device_account)
    data = { id: device_account.user.id, email: device_account.user.email }.to_json

    #TODO Should this be done with delayed jobs? Will it get to the service in time? How slow is this for 2+ callbacks?
    # Tell the service of the user creation
    service = device_account.service
    callbacks = service.callbacks.all(conditions: { callback_type_id: CallbackType.find_by(name: 'user_creation') })

    callbacks.each do |callback|
      begin
        uri = URI.parse callback.address

        request = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
        request.body = data
        
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        response = http.start do |h|
          h.request(request)
        end
        
      rescue => e
        #TODO Notify service that the callback is bad, maybe create a delayed job? Probably too late for that
        device_account.logger.error e.to_s
      end
    end if callbacks
  end
  
end

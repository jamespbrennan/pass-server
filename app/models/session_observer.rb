class SessionObserver < ActiveRecord::Observer
  
  def after_save(session)
    if(session.is_authenticated_changed? && session.is_authenticated)
      data = { session_id: session.id, is_authenticated: session.is_authenticated }.to_json

      #TODO Should this be done with delayed jobs? Will it get to the service in time? How slow is this for 2+ callbacks?
      # Tell the service of the successful authentication
      service = session.service
      callbacks = service.callbacks.all(conditions: { callback_type_id: CallbackType.find_by(name: 'authentication') })

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
          session.logger.error e.to_s
          session.logger.error response.to_s
        end
      end if callbacks

      # Tell node of the change
      $redis.publish 'session_updated', data
    end
  end
  
end

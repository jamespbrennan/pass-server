class SessionObserver < ActiveRecord::Observer
  
  def after_commit(session)
    if session.previous_changes.include?(:is_authenticated)
      data = { session_id: session.id, is_authenticated: session.is_authenticated }.to_json

      if session.is_authenticated
        #TODO Should this be done with delayed jobs? Will it get to the service in time? How slow is this for 2+ callbacks?
        # Tell the service of the successful authentication
        service = session.service
        callbacks = service.callbacks.where(callback_type_id: CallbackType.find_by(name: 'authentication')).to_a

        callbacks.each do |callback|
          begin
            uri = URI.parse callback.address

            request = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
            request.body = data

            http = Net::HTTP.new(uri.host, uri.port)

            if uri.class == URI::HTTPS
              http.use_ssl = true
              http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            end

            response = http.start do |h|
              h.request(request)
            end
            
          rescue => e
            #TODO Notify service that the callback is bad, maybe create a delayed job? Probably too late for that
            session.logger.error e.to_s
            session.logger.error response.to_s
          end
        end if callbacks
      end

      # Tell node of the change
      $redis.publish 'session_updated', data
    end

    true
  end
  
end

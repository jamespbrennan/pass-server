class SessionObserver < ActiveRecord::Observer
  
  def after_update(session)
    if(session.is_authenticated_changed? && session.is_authenticated)
      data = {session_id: session.id, is_authenticated: session.is_authenticated}.to_json

      #TODO Should this be done with delayed jobs? Will it get to the service in time? How slow is this for 2+ callbacks?
      # Tell the service of the successful authentication
      callbacks = session.service.callbacks.find(type: 'authentication')

      callback.each do |callback|
        begin
          uri = URI.parse callback

          request = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
          request.body = data
          response = Net::HTTP.new(uri.host, uri.port).start do |http|
            http.request(request)
          end
          
        rescue
          #TODO Notify service that the callback is bad, maybe create a delayed job? Probably too late for that
        end
      end

      # Tell node of the change
      $redis.publish 'session_updated', data.to_json
    end
  end
  
end

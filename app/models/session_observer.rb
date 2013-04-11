class SessionObserver < ActiveRecord::Observer
  
  def after_update(session)
    if(session.is_authenticated_changed? && session.is_authenticated)
      data = {session_id: session.id, is_authenticated: session.is_authenticated}.to_json

      # Tell the service of the successful authentication
      request = Net::HTTP::Post.new(@path, initheader = {'Content-Type' =>'application/json'})
      request.body = data
      response = Net::HTTP.new(@host, @port).start {|http| http.request(request) }

      # Tell node of the change
      
      $redis.publish 'session_updated', data.to_json
    end
  end
  
end

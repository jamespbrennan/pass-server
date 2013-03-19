class SessionObserver < ActiveRecord::Observer
  
  def after_update(session)
    if(session.is_authenticated_changed?)
      data = {session_id: session.id, is_authenticated: session.is_authenticated}

      $redis.publish 'session_updated', data.to_json
    end
  end
  
end

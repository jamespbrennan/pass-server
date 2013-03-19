class SessionObserver < ActiveRecord::Observer
  
  def after_update(session)
    if(session.is_authenticated_changed?)
      session.delay.report_updated
    end
  end
  
end

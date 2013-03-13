class SessionObserver < ActiveRecord::Observer
	observe Session

	def after_save(session)
		if(session.is_authenticated.changed?)
			session.delay.report_updated
		end
	end
end

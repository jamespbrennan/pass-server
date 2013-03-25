require 'spec_helper'

describe SessionObserver do
  subject { SessionObserver.instance }

  it 'calls #after_update when session is updated' do
    session = FactoryGirl.create(:session)
    session.is_authenticated = false
    subject.should_receive(:after_update).with(session)
    session.save
  end
end
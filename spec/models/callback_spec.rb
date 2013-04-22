# == Schema Information
#
# Table name: callbacks
#
#  id               :integer          not null, primary key
#  address          :string(255)
#  callback_type_id :integer
#  service_id       :integer
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe Callback do
  before do
    @callback = FactoryGirl.create(:callback)
  end

  it 'should only allow valid URLs' do
    @callback.address = 'blah'
    @callback.should_not be_valid
    @callback.address = 'ftp://blah.com'
    @callback.should_not be_valid

    @callback.address = 'http://blah.com'
    @callback.should be_valid
    @callback.address = 'https://blah.com'
    @callback.should be_valid
  end
end

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
  describe 'relations' do
    it { should belong_to :service }
    it { should belong_to :callback_type }
  end

  describe 'validations' do
    before do
      @callback = FactoryGirl.create(:callback)
    end

    it { should validate_presence_of :address }
    it { should validate_presence_of :callback_type_id }
    it { should validate_presence_of :service_id }

    it 'should only allow valid URLs' do
      @callback.address = 'blah'
      @callback.should_not be_valid
      @callback.address = 'ftp://blah.com'
      @callback.should_not be_valid

      @callback.address = 'http://blah.com'
      @callback.should_not be_valid
      @callback.address = 'https://blah.com'
      @callback.should be_valid
    end
  end

end

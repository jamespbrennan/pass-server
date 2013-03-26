# == Schema Information
#
# Table name: device_accounts
#
#  id         :integer          not null, primary key
#  public_key :text
#  created_at :datetime
#  updated_at :datetime
#  device_id  :integer
#  service_id :integer
#

require 'spec_helper'

describe DeviceAccount do
  describe 'associations' do
    it { should belong_to :device }
    it { should belong_to :service }
  end

  describe 'validation' do
    it { should validate_presence_of :device_id }
    it { should validate_presence_of :service_id }
    it { should validate_presence_of :public_key }
  end

  describe '#create' do
    before do
      @service = FactoryGirl.create(:service)
      @device = FactoryGirl.create(:device)
      @device_account = FactoryGirl.create(:device_account, device_id: @device.id, service_id: @service.id)
    end

    it 'should only except a valid RSA public key' do
      @device_account.valid?.should be_true
      @device_account.public_key = 'foo'
      @device_account.valid?.should_not be_true
    end
  end

end

# == Schema Information
#
# Table name: services
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  allowed_ip_addresses :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  url                  :string(255)
#

require 'spec_helper'

describe Service do
  describe 'associations' do
    it { should have_many :sessions }
    it { should have_many :device_accounts }
    it { should have_many :devices }
  end

  describe 'validation' do
    it { should validate_presence_of :url }
  end

  describe '#create' do
    before do
      @service = FactoryGirl.create(:service)
    end

    it 'should only except a valid URL' do
      @service.valid?.should be_true
      @service.url = 'foo'
      @service.valid?.should_not be_true
    end
  end

end

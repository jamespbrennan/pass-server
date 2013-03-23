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

    it 'should generate access token' do
      @service.access_token.should_not be_blank
    end

    it 'should generate a unique access token' do
      new_service = FactoryGirl.create(:service)
      @service.access_token.should_not == new_service.access_token
    end
  end

end
require 'spec_helper'

describe Device do

  describe 'associations' do
    it { should belong_to :device_type }
    it { should belong_to :user }
    it { should have_many :sessions }
    it { should have_many :device_accounts }
    it { should have_many :services }
  end

  describe 'validation' do
    it { should validate_presence_of :user_id }
  end

  describe "#create" do
    before do
      @device = FactoryGirl.create(:device)
    end

    it "should generate an access_token" do
      @device.access_token.should_not be_blank
    end

    it "should generate a unique access_token each time" do
      new_device = FactoryGirl.create(:device)
      @device.access_token.should_not == new_device.access_token
    end
  end
  
end
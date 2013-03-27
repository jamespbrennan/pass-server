# == Schema Information
#
# Table name: devices
#
#  id             :integer          not null, primary key
#  created_at     :datetime
#  updated_at     :datetime
#  device_type_id :integer
#  name           :string(255)
#  user_id        :integer
#

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

    it "should generate an api_token" do
      @device.api_token.should_not be_blank
    end
  end
  
end

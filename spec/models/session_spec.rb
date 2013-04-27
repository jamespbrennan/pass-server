# == Schema Information
#
# Table name: sessions
#
#  id                :integer          not null, primary key
#  user_agent        :string(255)
#  token             :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  is_authenticated  :boolean
#  device_id         :integer
#  service_id        :integer
#  remote_ip_address :inet
#  device_ip_address :inet
#  authenticated_at  :datetime
#

require 'spec_helper'

describe Session do

  describe 'relation' do
    it { should belong_to(:service) }
    it { should belong_to(:device) }
  end

  describe 'validation' do
    it { should validate_presence_of(:service_id) }
  end

  describe "#create" do
    before do
      @session = FactoryGirl.create(:session)
    end

    it "generates a token" do
      @session.token.should_not be_blank
    end

    it "generates a unique token each time" do
      new_session = FactoryGirl.create(:session)
      @session.token.should_not == new_session.token
    end
  end

end

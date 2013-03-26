# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  password_digest :string(255)
#

require 'spec_helper'

describe User do

  describe 'validation' do
    let!(:user) { FactoryGirl.create(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end

  describe "#create" do
    before do
      @user = FactoryGirl.create(:user)
    end
    
    it 'should require a valid email' do
      @user.valid?.should be_true
      @user.email = 'foo'
      @user.valid?.should_not be_true
    end

  end
end

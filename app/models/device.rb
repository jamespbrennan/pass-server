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

class Device < ActiveRecord::Base
  belongs_to :device_type
  belongs_to :user
  has_many :sessions
  has_many :device_accounts
  has_many :services, through: :device_accounts
  has_one :api_token, as: :api_consumer

  validates_presence_of :user_id, :name

  after_create :create_api_token

  private

  # == Generate API Token
  #
  # Make sure the device has a api_token
  #
  def create_api_token
    begin
      ApiToken.create(api_consumer: self)
    end
  end
end

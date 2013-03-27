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

class Service < ActiveRecord::Base
  has_many :sessions
  has_many :device_accounts
  has_many :devices, through: :device_accounts
  has_many :api_tokens, as: :api_consumer

  validates_presence_of :url
  validate :valid_url

  after_create :create_api_token

  private

  # == Valid URL
  #
  # Ensure there is a valid HTTPS URL
  #

  def valid_url
    throw Exception if ! URI.parse(self.url).kind_of?(URI::HTTP)
  rescue URI::InvalidURIError, Exception
    errors.add(:url, 'The URL attribute must contain a valid URL.')
  end

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

# == Schema Information
#
# Table name: services
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  access_token         :string(255)
#  allowed_ip_addresses :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  url                  :string(255)
#

class Service < ActiveRecord::Base
  has_many :sessions
  has_many :device_accounts
  has_many :devices, through: :device_accounts

  before_create :generate_access_token

  validates_presence_of :url
  # validate :valid_url

  private

  # == Generate Access Token
  #
  # Create the secret key for services to authenticate to the API with.
  # Ensure that another record with the same access_token does not exist.
  #

  def generate_access_token
  	begin
  		self.access_token = SecureRandom.hex
  	end while self.class.exists?(access_token: access_token)
  end

  # == Valid URL
  #
  # Ensure there is a valid URL
  #

  def valid_url
    if(URI.parse(self.url).kind_of?(URI::HTTP))
      errors.add(:url, 'The URL attribute must contain a valid URL.')
    end
  rescue URI::InvalidURIError
    errors.add(:url, 'The URL attribute must contain a valid URL.')
  end

end

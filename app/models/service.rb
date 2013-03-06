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
#

class Service < ActiveRecord::Base
  has_many :session

  before_create :generate_access_token

  private

  # Generate Access Token
  #
  # Create the secret key for services to authenticate to the API with.
  # Ensure that another record with the same access_token does not exist.
  #
  def generate_access_token
  	begin
  		self.access_token = SecureRandom.hex
  	end while self.class.exists?(access_token: access_token)
  end
end

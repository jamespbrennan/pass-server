# == Schema Information
#
# Table name: api_tokens
#
#  id                :integer          not null, primary key
#  token             :string(32)
#  api_consumer_id   :integer
#  api_consumer_type :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

class ApiToken < ActiveRecord::Base
  belongs_to :api_consumer, polymorphic: true

  before_create :generate_token

  private

  # == Generate Token
  #
  # Create the secret key for the device to authenticate to the API with.
  # Ensure that another record with the same token does not exist.
  #

  def generate_token
    begin
      self.token = SecureRandom.hex
    end while self.class.exists?(token: token)
  end

end

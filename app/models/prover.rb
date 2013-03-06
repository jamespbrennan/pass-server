# == Schema Information
#
# Table name: provers
#
#  id             :integer          not null, primary key
#  created_at     :datetime
#  updated_at     :datetime
#  device_type_id :integer
#  name           :string(255)
#  user_id        :integer
#  access_token   :string(255)
#

class Prover < ActiveRecord::Base
  belongs_to :device_type
  belongs_to :user
  has_many :session
  has_many :prover_account

  validates :user_id, :presence => true

  before_create :generate_access_token

  private

  # Generate Access Token
  #
  # Create the secret key for the prover to authenticate to the API with.
  # Ensure that another record with the same access_token does not exist.
  #
  def generate_access_token
  	begin
  		self.access_token = SecureRandom.hex
  	end while self.class.exists?(access_token: access_token)
  end
end

# == Schema Information
#
# Table name: api_tokens
#
#  id         :integer          not null, primary key
#  token      :string(255)
#  service_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class ApiToken < ActiveRecord::Base
  has_many :services

  before_create :generate_token

  private

  # == Generate Token
  #
  # Create the token
  #

  def generate_token
    self.token = SecureRandom.hex
  end

end

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
#

class Session < ActiveRecord::Base
  belongs_to :service
  belongs_to :device
  has_one :user, through: :device

  validates :service_id, :presence => true

  before_create :generate_token
  before_update :set_authenticated_at

  private

  # == Generate Token
  #
  # Create the nonce for the session
  #

  def generate_token
		self.token = SecureRandom.hex
  end

  def set_authenticated_at
    self.authenticated_at = Time.zone.now if self.is_authenticated_changed?
  end

end

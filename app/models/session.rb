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

  validates :service_id, :presence => true
  validate :preserve_device_id

  before_create :generate_token

  private

  # Generate Token
  #
  # Create the nonce for the session
  #
  def generate_token
		self.token = SecureRandom.hex
  end

  # Preserve Device ID
  #
  # Do not let device ids that have been set, be updated
  #
  def preserve_device_id
    if(self.device_id_changed? && self.device_id_was != nil)
      errors.add(:device_id, 'You cannot update a device id that has already been set.')
    end
  end

  # Report Updated
  #
  # Send message to notify the browser that the session has been updated
  #
  def report_updated
    data = {id: self.id, is_authenticated: self.is_authenticated}

    $redis.publish 'session_updated', data.to_json
  end

end

# == Schema Information
#
# Table name: sessions
#
#  id               :integer          not null, primary key
#  ip_address       :string(255)
#  user_agent       :string(255)
#  token            :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  service_id       :integer
#  device_id        :integer
#  is_authenticated :boolean
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
    Messenger.publish_message('session_updated', {id: self.id, is_authenticated: self.is_authenticated})
  end

end

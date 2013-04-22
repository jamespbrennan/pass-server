# == Schema Information
#
# Table name: device_accounts
#
#  id         :integer          not null, primary key
#  public_key :text
#  created_at :datetime
#  updated_at :datetime
#  device_id  :integer
#  service_id :integer
#

class DeviceAccount < ActiveRecord::Base
	belongs_to :device
	belongs_to :service

	validates :device_id, :service_id, :public_key, :presence => true
  validate :valid_public_key

  def sessions
    self.device.sessions.find(:all, conditions: ['service_id = ?', self.service_id])
  end

  private

  def valid_public_key
    if self.public_key_changed?
      begin
        throw Exception unless OpenSSL::PKey::RSA.new(self.public_key).public?
      rescue
        errors.add(:public_key, 'The public_key attribute must contain a valid RSA public key.')
      end
    end
  end
end

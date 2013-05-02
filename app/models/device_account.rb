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
  has_one :user, through: :device

	validates :device_id, :service_id, :public_key, :presence => true
  validate :valid_public_key

  def sessions(options = { limit: 10 })
    options[:conditions] = ['service_id = ?', self.service_id]
    self.device.sessions.find(:all, options)
  end

  private

  def valid_public_key
    if self.public_key_changed?
      begin
        raise unless Crypto::VerifyKey.new(self.public_key, :hex)
      rescue
        errors.add(:public_key, 'The public_key attribute must contain a valid NaCL Crypto public key.')
      end
    end
  end
end

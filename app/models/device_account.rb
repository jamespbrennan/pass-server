# == Schema Information
#
# Table name: device_accounts
#
#  id         :integer          not null, primary key
#  public_key :string(255)
#  device_id  :integer
#  service_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class DeviceAccount < ActiveRecord::Base
	belongs_to :device
	belongs_to :service

	validates :device_id, :service_id, :public_key, :presence => true
end

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
end

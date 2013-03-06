# == Schema Information
#
# Table name: device_types
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  identifier   :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  manufacturer :string(255)
#  model        :string(255)
#

class DeviceType < ActiveRecord::Base
end

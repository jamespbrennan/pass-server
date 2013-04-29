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

require 'spec_helper'

describe DeviceType do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :identifier }
    it { should validate_presence_of :manufacturer }
    it { should validate_presence_of :model }
  end
end

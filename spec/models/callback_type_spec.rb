# == Schema Information
#
# Table name: callback_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe CallbackType do
  describe 'validations' do
    it { should validate_presence_of :name }
  end
end

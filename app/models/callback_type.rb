# == Schema Information
#
# Table name: callback_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class CallbackType < ActiveRecord::Base
end

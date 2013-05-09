# == Schema Information
#
# Table name: developer_accounts
#
#  id         :integer          not null, primary key
#  service_id :integer
#  user_id    :integer
#  is_admin   :boolean
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe DeveloperAccount do
end

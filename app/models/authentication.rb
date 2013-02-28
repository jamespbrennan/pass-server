# == Schema Information
#
# Table name: authentications
#
#  id         :integer          not null, primary key
#  ip_address :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  prover_id  :integer
#  service_id :integer
#

class Authentication < ActiveRecord::Base
  belongs_to :prover
  belongs_to :service
end

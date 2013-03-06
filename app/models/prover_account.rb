# == Schema Information
#
# Table name: prover_accounts
#
#  id         :integer          not null, primary key
#  public_key :string(255)
#  prover_id  :integer
#  service_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class ProverAccount < ActiveRecord::Base
	belongs_to :prover
	belongs_to :service
	
	validates :prover_id, :service_id, :public_key, :presence => true
end

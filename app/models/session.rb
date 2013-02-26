# == Schema Information
#
# Table name: sessions
#
#  id         :integer          not null, primary key
#  ip_address :string(255)
#  user_agent :string(255)
#  token      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  service_id :integer
#  prover_id  :integer
#

class Session < ActiveRecord::Base
  attr_accessible :ip_address, :token, :user_agent

  belongs_to :service
  has_one :prover

  validates :service_id, :presence => true
  # validates_associated :service

  before_create :generate_token
  before_save :preserver_prover_id

  private

  # Generate Token
  #
  # Create the nonce for the session
  #
  def generate_token
  	begin
  		self.token = SecureRandom.hex
  	end
  end

  def preserve_prover_id
    begin
      # if(self.prover)
    end
  end
end

# == Schema Information
#
# Table name: callbacks
#
#  id               :integer          not null, primary key
#  address          :string(255)
#  callback_type_id :integer
#  service_id       :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Callback < ActiveRecord::Base
  belongs_to :service
  belongs_to :callback_type

  validates_presence_of :address, :callback_type_id, :service_id
  validate :valid_address

  private

  def valid_address
    if address_changed?
      errors.add(:address, 'The address attribute must contain a valid URI.') unless [URI::HTTP, URI::HTTPS].include? URI.parse(self.address).class
    end
  end
end

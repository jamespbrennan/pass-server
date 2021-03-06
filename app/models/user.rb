# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  password_digest :string(255)
#

class User < ActiveRecord::Base

	has_secure_password

	has_many :devices
  has_many :device_accounts, through: :devices
  has_many :developer_accounts

  validates_presence_of :password, :on => :create
  validates_presence_of :email
	validates_uniqueness_of :email
	validates :email, :format => { :with => /@/ }
	
end

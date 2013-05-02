# == Schema Information
#
# Table name: sessions
#
#  id                :integer          not null, primary key
#  user_agent        :string(255)
#  token             :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  is_authenticated  :boolean
#  device_id         :integer
#  service_id        :integer
#  remote_ip_address :inet
#  device_ip_address :inet
#  authenticated_at  :datetime
#

class Session < ActiveRecord::Base
  belongs_to :service
  belongs_to :device
  has_one :user, through: :device

  validates :service_id, :presence => true

  before_create :generate_token
  before_update :set_authenticated_at

  after_commit :notify_parties, :if => Proc.new { |session| session.is_authenticated_changed? && session.is_authenticated }

  private

  # == Generate Token
  #
  # Create the nonce for the session
  #

  def generate_token
		self.token = SecureRandom.hex
  end

  def set_authenticated_at
    self.authenticated_at = Time.zone.now if self.is_authenticated_changed?
  end

  def notify_parties(session)
    data = { session_id: session.id, is_authenticated: session.is_authenticated }.to_json

    #TODO Should this be done with delayed jobs? Will it get to the service in time? How slow is this for 2+ callbacks?
    # Tell the service of the successful authentication
    service = session.service
    callbacks = service.callbacks.all(conditions: { callback_type_id: CallbackType.find_by(name: 'authentication') })

    callbacks.each do |callback|
      begin
        uri = URI.parse callback.address

        request = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
        request.body = data

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        response = http.start do |h|
          h.request(request)
        end
        
      rescue => e
        #TODO Notify service that the callback is bad, maybe create a delayed job? Probably too late for that
        session.logger.error e.to_s
        session.logger.error response.to_s
      end
    end if callbacks

    # Tell node of the change
    $redis.publish 'session_updated', data

    true
  end

end

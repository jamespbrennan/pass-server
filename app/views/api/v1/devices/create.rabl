object @device
attributes :id, :name, :created_at

node :token do |device|
  device.api_token.token
end

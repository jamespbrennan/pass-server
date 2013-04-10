object @session
attributes :id, :service_id, :device_id, :is_authenticated

node(:message) { 'Successful authentication.' }
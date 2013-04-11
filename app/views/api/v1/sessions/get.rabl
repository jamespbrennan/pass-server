object @session
attributes :id, :service_id

child(:user) { attributes :id, :email }
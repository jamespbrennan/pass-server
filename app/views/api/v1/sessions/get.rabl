object @session
attributes :id, :service_id, :is_authenticated

child(:user) { attributes :id, :email }
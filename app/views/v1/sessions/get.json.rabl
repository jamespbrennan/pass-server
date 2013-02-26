object @session
attributes :id, :service_id, :prover_id, :token, :created_at

node :errors do |o|
  o.errors
end
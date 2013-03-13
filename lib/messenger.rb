require 'SocketIO'

class Messenger
	def send_message(event, data)
		client = SocketIO.connect("http://localhost:8080") do
			after_start do
				emit(event, data)
			end
		end
	end
end
module Pass
  class Messenger

    def send_message(event, data)
      logger = Logger.new(STDOUT);
      logger.debug("send_message");
      client = SocketIO.connect("http://127.0.0.1:8080") do
        after_start do
          client.emit(event, data)
          client.disconnect
        end
      end
    end

  end
end
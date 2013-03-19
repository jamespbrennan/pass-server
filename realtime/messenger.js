var socketio = require('socket.io')
  , redis = require('redis').createClient();

redis.subscribe('session_updated');

socketio.listen(server).on('connection', function (socket) {

  socket.on('subscribe', function(message) {
    // Join the client to a room based on their session_id
    if( typeof message.session_id != "undefined" ) {
      socket.join("session_" + message.session_id);
    } else {
      socket.send_message("error", "Subscribe message must include `session_id`.");
    }
  });

  redis.on('message', function(channel, message) {
    // Message comes in as a string, parse it so we can get to it's attributes
    message = JSON.parse(message);

    if( typeof message.session_id != "undefined" ) {
      // Send the message only to the clients in the session_id room
      socket.broadcast.to("session_" + message.session_id).emit(channel, message);
      // channel is an event, likey `session_updated`, `message` is the JSON for the event
    }
  });

});
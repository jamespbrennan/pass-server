var http = require('http')
  , server = http.createServer().listen(8080)
  , socketio = require('socket.io')
  , io = socketio.listen(server)
  , redis = require('redis').createClient();

// Reduce loggin
io.set('log level', 1);

redis.subscribe('session_updated');
redis.on('message', function(channel, message) {
  // Message comes in as a string, parse it so we can get to it's attributes
  message = JSON.parse(message);

  console.log(message);

  io.sockets.in("session_" + message.session_id).emit("channel", "message");
  io.sockets.in("session_" + message.session_id).emit("message", "message");

  if( typeof message.session_id != "undefined") {
    // Send the message only to the clients in the session_id room
    // channel is an event, likey `session_updated`, `message` is the JSON for the event
    io.sockets.in("session_" + message.session_id).emit(channel, message);
  }
});

io.sockets.on('connection', function (socket) {
  socket.on('subscribe', function(session_id) {
    // Join the client to a room based on their session_id
    socket.join("session_" + session_id);
    console.log("Clients in:  " + io.sockets.in("session_" + session_id).length);
  });
});
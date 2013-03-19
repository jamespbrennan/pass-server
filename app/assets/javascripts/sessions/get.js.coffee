create_qrcode = (text, typeNumber = 4, errorCorrectLevel = 'M') ->
  qr = qrcode(typeNumber, errorCorrectLevel)
  qr.addData(text)
  qr.make()
  qr.createTableTag(4)

window.onload = () ->
  # Create the QR code
  qr_wrapper = document.getElementById('qr-wrapper')
  text = qr_wrapper.dataset.sessionId + ':' + qr_wrapper.dataset.serviceId + ':' + qr_wrapper.dataset.token
  qr_wrapper.innerHTML = create_qrcode(text)

  # Connect to the Socket.IO server
  socket = io.connect('http://localhost:8080')

  # When the session is updated, notify the parent page
  socket.on('session_updated', (message) ->
    iframe = document.getElementsById('pass-login')
    iframe.contentWindow.postMessage(message, 'http://localhost')
  )

  # Subscribe to a room based on the session_id
  socket.emit('subscribe', qr_wrapper.dataset.sessionId)

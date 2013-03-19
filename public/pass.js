window._pass = window._pass || [];

function receiver(e) {
  console.log(e);
  if (e.origin == 'http://localhost') {
    alert(e.data);
  }
}

(function() {
	var iframe
  , target
  , session_id = window._pass.session_id;

  if( ! session_id ) throw new Error('window._pass.session_id must be set to a valid session_id');

  iframe = document.createElement('iframe');
  iframe.src = 'http://localhost:3000/sessions/get?id=' + session_id;
  iframe.id = 'pass-login';
  iframe.seamless = true;
  iframe.frameborder = 0;
	
  if( window._pass.target )
  {
    if(typeof window._pass.target == "object")
    {
      // Node object or node list? Make sure we're dealing with a node
      target = (window._pass.target.length > 0) ? window._pass.target[0] : window._pass.target;
    }
    else
    {
      // Get it by id
      if(typeof window._pass.target == "string" && window._pass.target)
      {
        target = document.getElementById(window._pass.target)
      }
    }
  }

  if( typeof target == "undefined") target = document.getElementsByTagName('body')[0];

	target.appendChild(iframe);

  window.addEventListener('message', receiver, false);

})();

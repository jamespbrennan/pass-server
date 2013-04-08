window._pass = window._pass || {};

(function() {
	var iframe
  , target
  , session_id = window._pass.session_id;

  if( ! session_id ) throw new Error('window._pass.session_id must be set to a valid session_id');

  iframe = document.createElement('iframe');
  iframe.src = 'https://api.passauth.net/sessions/get?id=' + session_id;
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

  window.addEventListener('message', function(e) {
      if (e.origin == 'https://api.passauth.net') {
        if(e.data.is_authenticated) {
          // If no page is provided to redirect to, just refresh the current page
          if( ! window._pass.redirect_to ) self.location.reload(true);
          
          window.location.assign(window._pass.redirect_to);
        } else {
          alert("I'm sorry, but something must have gone wrong or your session has expired. The page will reload and you can try again.");
          self.location.reload(true);
        }
      }
    }, false);

})();

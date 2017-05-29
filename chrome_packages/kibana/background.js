chrome.app.runtime.onLaunched.addListener(function() {
  chrome.app.window.create('webview.html', {
    'outerBounds': {
      'width': 1280,
      'height': 720
    }
  });
});

var prefs = new _IG_Prefs();
var mpageURL = prefs.getString("mpageURL");
function mpageCallback(response) {
  var html = '<link href="'+ response.stylesheet +'" rel="Stylesheet" type="text/css"/>';
  html += "<div id=\"content\" class=\"wiki\">" + response.content + "</div>";
  document.getElementById('panel').innerHTML = html
  _IG_AdjustIFrameHeight();
  window.setTimeout(5000, function() {
    _IG_AdjustIFrameHeight();
  })
}

document.write("<script src='" + mpageURL + "'  type='text/javascript'></script>")

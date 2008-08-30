var prefs = new _IG_Prefs();
var pageName = prefs.getString("pageName").strip();
var projectURL = prefs.getString("projectURL").strip();

var action = [projectURL, 'macros.json'].join('/');
var url = action + "?jsonp=response&pagename=" + encodeURIComponent(pageName);

function response(responseText) {
  $('panel').innerHTML = responseText;
  _IG_AdjustIFrameHeight();
}
document.write("<script src='" + url + "'  type='text/javascript'></script>")

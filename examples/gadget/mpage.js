var prefs = new _IG_Prefs();
var pageName = prefs.getString("pageName").strip();
var projectURL = prefs.getString("projectURL").strip();

var action = [projectURL, 'mpages.json'].join('/');
var url = action + "?jsonp=responseHandler&pagename=" + encodeURIComponent(pageName);

function responseHandler(response) {
  var html = '<link href="'+ response.stylesheet +'" rel="Stylesheet" type="text/css"/>';
  html += "<div id=\"content\" class=\"wiki\">" + response.content + "</div>";
  $('panel').innerHTML = html
  _IG_AdjustIFrameHeight();
}

document.write("<script src='" + url + "'  type='text/javascript'></script>")

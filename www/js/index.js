// Generated by CoffeeScript 1.3.3
var App, app, programXML, xmlLoader;

App = (function() {

  App.programXML;

  function App() {
    document.addEventListener('deviceready', this.deviceready(), false);
  }

  App.prototype.deviceready = function() {
    var a, date, dateSplitted, dayIndex, dayNode, dayTab, pageHref, _i, _len, _ref, _results;
    _ref = programXML.find('day');
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      dayNode = _ref[_i];
      dayNode = $(dayNode);
      date = dayNode.attr('date');
      dateSplitted = date.split('-');
      dayNode.dayForUI = parseInt(dateSplitted[2]) + '. ' + helper.i18nDateFormats.monthNames[parseInt(dateSplitted[1]) - 1];
      dayTab = $('.tabs li:first').clone();
      dayIndex = dayNode.attr('index');
      dayTab.attr({
        'data-day-index': dayIndex
      });
      pageHref = "#schedule#" + dayIndex;
      a = dayTab.find('a:first');
      a.attr('href', pageHref);
      a.html(dayNode.dayForUI);
      a.removeClass('ui-btn-active');
      a.removeClass('ui-state-persist');
      $('.tabs').append($('<div />').append(dayTab.show()).html());
      if (helper.formatDate(new Date(), 'yyyy-mm-dd') === date) {
        _results.push(document.location.href = pageHref);
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  return App;

})();

xmlLoader = new ScheduleXMLLoader();

xmlLoader.appStartUpLoad();

programXML = xmlLoader.getXMLTree();

$(document).bind('pagebeforechange', function(e, data) {
  var dayNode, eventNode, parsedUrl, parsedUrlHash, roomNode;
  if (typeof data.toPage !== 'string') {
    return;
  }
  parsedUrl = $.mobile.path.parseUrl(data.toPage);
  if (!parsedUrl.filename === 'index.html') {
    return;
  }
  if (/^#schedule#/.test(parsedUrl.hash)) {
    $('li[data-day-index] .link').removeClass('ui-btn-active');
    dayNode = $(programXML.find('day[index=' + parsedUrl.hash.split('#')[2] + ']:first'));
    scheduleView.initialize(dayNode, data.option);
    $('#event-back').attr('href', parsedUrl.href);
    return e.preventDefault();
  } else if (/^#personalSchedule$/.test(parsedUrl.hash)) {
    return $('li[data-day-index] .link').removeClass('ui-btn-active');
  } else if (/^#event#[0-9]+#.*#[0-9]+$/.test(parsedUrl.hash)) {
    parsedUrlHash = parsedUrl.hash.split('#');
    dayNode = $(programXML.find('day[index=' + unescape(parsedUrlHash[2]) + ']:first'));
    roomNode = $(dayNode.find('room[name="' + unescape(parsedUrlHash[3]) + '"]:first'));
    eventNode = $(roomNode.find('event[id=' + unescape(parsedUrlHash[4]) + ']:first'));
    eventView.initialize(eventNode, data.option);
    return e.preventDefault();
  }
});

app = new App();

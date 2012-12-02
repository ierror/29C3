// Generated by CoffeeScript 1.4.0
var App, app, personalSchedule, programXML, xmlLoader;

App = (function() {

  function App() {
    document.addEventListener('deviceready', this.deviceready(), false);
  }

  App.prototype.deviceready = function() {
    var a, date, dateSplitted, dayIndex, dayNode, dayTab, dayTab2Load, pageHref, platform, ua, _i, _len, _ref;
    ua = navigator.userAgent;
    platform = {
      ios: ua.match(/(iPhone|iPod|iPad)/),
      android: ua.match(/Android/)
    };
    if (platform.android) {
      document.write("<script src=\"lib/js/cordova-2.1.0-Android.js\"></script>");
      document.write("<script src=\"lib/js/ChildBrowser-Android.js\"></script>");
    } else if (platform.ios) {
      document.write("<script src=\"lib/js/cordova-2.1.0-iOS.js\"></script>");
      document.write("<script src=\"lib/js/ChildBrowser-iOS.js\"></script>");
    }
    dayTab2Load = void 0;
    _ref = programXML.find('day');
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
        dayTab2Load = pageHref;
      }
      scheduleView.initialize(dayNode);
    }
    if (!dayTab2Load) {
      return personalScheduleView.initialize();
    } else {
      return $(document).ready(function() {
        return $.mobile.changePage(dayTab2Load);
      });
    }
  };

  return App;

})();

xmlLoader = new ScheduleXMLLoader();

xmlLoader.appStartUpLoad();

programXML = xmlLoader.getXMLTree();

personalSchedule = new PersonalSchedule();

$(document).bind('pagebeforechange', function(e, data) {
  var dayNode, eventNode, last_active_page, page_link, parsedUrl, parsedUrlHash, roomNode;
  if (typeof data.toPage !== 'string') {
    return;
  }
  parsedUrl = $.mobile.path.parseUrl(data.toPage);
  if (!parsedUrl.filename === 'index.html') {
    return;
  }
  $('body').addClass('ui-loading');
  $('a.tab').removeClass('ui-btn-active');
  if (/^#schedule#/.test(parsedUrl.hash)) {
    parsedUrlHash = parsedUrl.hash.split('#');
    dayNode = $(programXML.find('day[index=' + parsedUrlHash[2] + ']:first'));
    page_link = "#schedule#" + parsedUrlHash[2];
    $('body').attr('data-last-active-page', page_link);
  } else if (/^#personalSchedule$/.test(parsedUrl.hash)) {
    $('body').attr('data-last-active-page', parsedUrl.hash);
  } else if (/^#event#[0-9]+#.*#[0-9]+$/.test(parsedUrl.hash)) {
    parsedUrlHash = parsedUrl.hash.split('#');
    dayNode = $(programXML.find('day[index=' + unescape(parsedUrlHash[2]) + ']:first'));
    roomNode = $(dayNode.find('room[name="' + unescape(parsedUrlHash[3]) + '"]:first'));
    eventNode = $(roomNode.find('event[id=' + unescape(parsedUrlHash[4]) + ']:first'));
    eventView.initialize(eventNode, data.option);
    e.preventDefault();
  }
  last_active_page = $('body').attr('data-last-active-page');
  if (last_active_page) {
    $("a.tab[href='" + last_active_page + "']").addClass('ui-btn-active');
  }
  return $('body').removeClass('ui-loading');
});

$(document).bind('pagechange', function(e, data) {
  var last_scroll_pos, pageID;
  pageID = data.toPage.attr('data-url');
  last_scroll_pos = userconfig.getItem("last-scroll-pos-" + pageID);
  if (last_scroll_pos && $(window).scrollTop() !== last_scroll_pos) {
    return $('html, body').scrollTop(last_scroll_pos);
  }
});

$(document).on('click', '.external-link', function() {
  window.plugins.childBrowser.showWebPage($(this).attr('href'));
  return false;
});

$(window).resize(function() {
  $('.ui-header').width($(window).width());
  return $('.ui-footer').width($(window).width());
});

$(window).bind('scrollstop', function() {
  var pageID;
  pageID = $.mobile.activePage.attr('id');
  if (pageID !== 'event') {
    return userconfig.setItem('last-scroll-pos-' + pageID, $(window).scrollTop());
  }
});

app = new App();

// Generated by CoffeeScript 1.3.3
var PersonalScheduleView, personalScheduleView;

PersonalScheduleView = (function() {

  function PersonalScheduleView() {}

  PersonalScheduleView.page;

  PersonalScheduleView.prototype._resetLayout = function() {
    var contentDiv;
    contentDiv = $('div[data-role=content]:first', this.page);
    return $('ul[data-role=listview]:first', contentDiv).html('');
  };

  PersonalScheduleView.prototype.initialize = function(eventNode, options) {
    var contentDiv, date, dateSplitted, dayNode, event, eventDateKey, eventID, eventsSorted, headerContent, lastHeaderContent, listView, listViewLiElementTpl, listViewLiHeaderTpl, roomNode, start, _i, _j, _len, _len1, _listViewLiElementTpl, _listViewLiElementTplLink, _listViewLiHeaderTpl, _ref, _ref1;
    this.page = $('#personalSchedule');
    this._resetLayout();
    eventsSorted = {};
    _ref = personalSchedule.db.getData();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      eventID = _ref[_i];
      event = $(programXML.find("event[id='" + eventID + "']:first"));
      roomNode = event.parent();
      dayNode = roomNode.parent();
      date = dayNode.attr('date');
      dateSplitted = date.split('-');
      start = parseFloat(event.find('start:first').text().replace(':', '.'));
      if (parseInt(start) < 11) {
        start = start + 24;
      }
      eventsSorted[date + start + event.attr('id')] = {
        title: event.find('title:first').text(),
        href: '#event#' + escape(dayNode.attr('index')) + '#' + escape(roomNode.attr('name')) + '#' + escape(eventID),
        start: event.find('start:first').text(),
        dayForUI: parseInt(dateSplitted[2]) + '. ' + helper.i18nDateFormats.monthNames[parseInt(dateSplitted[1]) - 1]
      };
    }
    contentDiv = $('div[data-role=content]:first', this.page);
    listView = $('ul[data-role=listview]:first', contentDiv);
    listViewLiElementTpl = $('.tpl.element:first', contentDiv);
    listViewLiHeaderTpl = $('.tpl.header:first', contentDiv);
    lastHeaderContent = void 0;
    _ref1 = helper.getObjKeys(eventsSorted).sort();
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      eventDateKey = _ref1[_j];
      event = eventsSorted[eventDateKey];
      headerContent = event.dayForUI;
      if (lastHeaderContent !== headerContent) {
        _listViewLiHeaderTpl = listViewLiHeaderTpl.clone().removeClass('tpl');
        _listViewLiHeaderTpl.html(headerContent);
        listView.append(_listViewLiHeaderTpl);
        lastHeaderContent = headerContent;
      }
      _listViewLiElementTpl = listViewLiElementTpl.clone().removeClass('tpl');
      _listViewLiElementTplLink = _listViewLiElementTpl.find('a:first');
      _listViewLiElementTplLink.attr('href', event.href);
      _listViewLiElementTplLink.html(event.start + ': ' + event.title);
      listView.append(_listViewLiElementTpl);
    }
    return listView.listview('refresh');
  };

  return PersonalScheduleView;

})();

personalScheduleView = new PersonalScheduleView();

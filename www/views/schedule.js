// Generated by CoffeeScript 1.4.0
var scheduleView;

scheduleView = {
  initialize: function(dayNode, options) {
    var dayIndex, duration, durationHours, durationMinutes, durationSplitted, eventHref, eventID, eventNode, page, page_id, roomName, roomNode, rowspan, td, th, theadRow, _i, _j, _len, _len1, _ref, _ref1, _results;
    dayIndex = dayNode.attr('index');
    page = $('#schedule').clone();
    theadRow = page.find('thead tr', page);
    page_id = "schedule#" + dayIndex;
    page.attr('id', page_id);
    page.attr('data-url', page_id);
    page.attr('data-day-index', dayIndex);
    _ref = dayNode.find('room');
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      roomNode = _ref[_i];
      roomNode = $(roomNode);
      roomName = roomNode.attr('name');
      if (!roomName) {
        continue;
      }
      th = $("<th style='width=100%'>" + roomName + "</th>").attr('data-is-room-column', 1);
      theadRow.append(th);
      _ref1 = roomNode.find('event');
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        eventNode = _ref1[_j];
        eventNode = $(eventNode);
        duration = eventNode.find('duration:first').text();
        durationSplitted = duration.split(':');
        durationHours = durationSplitted[0];
        durationMinutes = durationSplitted[1];
        rowspan = durationHours * 4 + durationMinutes / 15;
        eventID = eventNode.attr('id');
        eventHref = '#event#' + escape(dayIndex) + '#' + escape(roomName) + '#' + escape(eventID);
        td = $(("<td id='event-" + eventID + "' style='background-color: #d3d3d3;' rowspan='" + rowspan + "'><a href='" + eventHref + "'> ") + eventNode.find('title:first').text() + '</a></td>').attr('data-is-event-cell', 1);
        if (personalSchedule.db.contains(eventID)) {
          td.addClass('event-attend');
        }
        $('.timeslot-' + eventNode.find('start:first').text().replace(':', ''), page).append(td);
      }
      _results.push($('body').append(page));
    }
    return _results;
  }
};

// Generated by CoffeeScript 1.4.0
var Event, eventView;

Event = (function() {

  function Event() {}

  Event.page;

  Event.prototype._setField = function(targetElement, value) {
    return targetElement.append(value);
  };

  Event.prototype._resetLayout = function() {
    return $('[data-is-event-field=true]', this.page).each(function() {
      var eventElement;
      eventElement = $(this);
      if (eventElement.find('.tpl').length) {
        return eventElement.children(':not(.tpl)').remove();
      } else {
        return eventElement.html('');
      }
    });
  };

  Event.prototype.initialize = function(eventNode, options) {
    var attendCheckbox, attendStatusChanged, childField, childFieldRound, children, duration_splitted, end_hour, end_minute, end_time, event, eventField, eventID, eventText, fieldName, liTpl, start_splitted, start_time, targetElement, _i, _j, _k, _len, _len1, _len2, _liTpl, _liTplLink, _ref, _ref1, _ref2;
    event = this;
    this.page = $('#event');
    this._resetLayout();
    eventID = eventNode.attr('id');
    start_time = eventNode.find('start:first').text();
    start_splitted = start_time.split(':');
    duration_splitted = eventNode.find('duration:first').text().split(':');
    end_minute = parseInt(start_splitted[1]) + parseInt(duration_splitted[1]);
    end_hour = 0;
    if (end_minute >= 60) {
      end_hour = 1;
      end_minute = end_minute - 60;
    }
    end_hour = parseInt(start_splitted[0]) + parseInt(duration_splitted[0]) + end_hour;
    if (end_hour >= 24) {
      end_hour = end_hour - 24;
    }
    end_time = helper.pad(end_hour, 2) + ':' + helper.pad(end_minute, 2);
    this._setField($('#event-start-end'), start_time + ' - ' + end_time);
    _ref = eventNode.children();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      eventField = _ref[_i];
      fieldName = eventField.tagName;
      eventField = $(eventField);
      targetElement = $("#event-" + fieldName, this.page);
      eventText = '';
      children = eventField.children();
      if (fieldName !== 'links') {
        if (children.length > 1) {
          childFieldRound = 0;
          _ref1 = eventField.children();
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            childField = _ref1[_j];
            childFieldRound++;
            if (childFieldRound > 1) {
              eventText += ', ';
            }
            eventText += $(childField).text();
          }
        } else {
          eventText = eventField.text();
        }
      } else {
        liTpl = targetElement.find('li:first').clone().show();
        _ref2 = eventField.children();
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          childField = _ref2[_k];
          childField = $(childField);
          _liTpl = liTpl.clone();
          _liTpl.removeClass('tpl');
          _liTplLink = _liTpl.find('a:first');
          _liTplLink.html(childField.text());
          _liTplLink.attr('href', childField.attr('href'));
          eventText += $('<div/>').append(_liTpl).html();
        }
      }
      this._setField(targetElement, eventText);
    }
    attendCheckbox = $('#event-attend-checkbox').checkboxradio();
    attendCheckbox.attr('data-event-id', eventID);
    attendStatusChanged = false;
    attendCheckbox.bind('change', function(event, ui) {
      var self;
      self = $(this);
      attendStatusChanged = true;
      eventID = self.attr('data-event-id');
      if (!self.attr('checked')) {
        self.removeAttr('checked').checkboxradio('refresh');
        self.parent().find('.ui-btn-text:first').html(self.attr('data-event-attend-text'));
        self.parent().removeClass('attended');
        $("#event-" + eventID).removeClass('event-attend');
        return personalSchedule.db.remove(eventID);
      } else {
        self.attr('checked', 'checked').checkboxradio('refresh');
        self.parent().find('.ui-btn-text:first').html(self.attr('data-event-dontattend-text'));
        self.parent().addClass('attended');
        $("#event-" + eventID).addClass('event-attend');
        return personalSchedule.db.push(eventID);
      }
    });
    if (personalSchedule.db.contains(eventID)) {
      attendCheckbox.attr('checked', 'checked').checkboxradio('refresh');
      attendCheckbox.parent().addClass('attended');
      attendCheckbox.parent().find('.ui-btn-text:first').html(attendCheckbox.attr('data-event-dontattend-text'));
    } else {
      attendCheckbox.removeAttr('checked').checkboxradio('refresh');
      attendCheckbox.parent().removeClass('attended');
      attendCheckbox.parent().find('.ui-btn-text:first').html(attendCheckbox.attr('data-event-attend-text'));
    }
    return $.mobile.changePage(this.page);
  };

  return Event;

})();

eventView = new Event();

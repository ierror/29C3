class Event
  @page

  _setField: (targetElement, value) ->
    targetElement.append(value)

  _resetLayout: ->
    # check for tpls within our event elements
    # if there exists a tpl element, don't remove it
    $('[data-is-event-field=true]', @page).each ->
      eventElement = $(@)
      if eventElement.find('.tpl').length
        eventElement.children(':not(.tpl)').remove()
        # there is no tpl found, simple set html to ''
      else
        eventElement.html('')

  initialize: (eventNode, options) ->
    event = @

    @page = $('#event')
    @_resetLayout()

    eventID = eventNode.attr('id')

    for eventField in eventNode.children()
      fieldName = eventField.tagName
      eventField = $(eventField)

      targetElement = $("#event-#{fieldName}", @page)
      eventText = ''
      children = eventField.children()

      # <links> need special handling
      if fieldName != 'links'
        if children.length > 1
          childFieldRound = 0
          for childField in eventField.children()
            childFieldRound++
            eventText += ', ' if childFieldRound > 1
            eventText += $(childField).text()
        else
          eventText = eventField.text()

        # <links> handling
      else
        # if there is a <ul> element defined within the target element,
        # fill it by li elements
        liTpl = targetElement.find('li:first').clone().show()
        for childField in eventField.children()
          childField = $(childField)
          _liTpl = liTpl.clone()
          _liTpl.removeClass('tpl')
          _liTplLink = _liTpl.find('a:first')
          _liTplLink.html(childField.text())
          _liTplLink.attr('href', childField.attr('href'))
          eventText += $('<div/>').append(_liTpl).html()

      @_setField(targetElement, eventText)

    # set hashtag
    hashTag = "#29C3_#{eventID}"
    twitterElement = $('#event-twitter', @page)
    $('.event-twitter-hashtag:first', twitterElement).html(hashTag)

    ulElement = $('ul:first', twitterElement)
    ulElement.find('.event-twitter-tweet:first').attr('href', 'tweetbot:///post?text=' + escape('  ' + hashTag) + '&callback_url=' + escape('congress2012://'))
    ulElement.find('.event-twitter-list:first').attr('href', '#twitter#' + escape(hashTag))

    attendCheckbox = $('#event-attend-checkbox').checkboxradio()
    attendCheckbox.attr('data-event-id', eventID)

    attendCheckbox.bind 'change', (event, ui) ->
      self = $(@)
      if not self.attr('checked')
        self.removeAttr('checked').checkboxradio('refresh')
        self.parent().find('.ui-btn-text:first').html(self.attr('data-event-attend-text'))
        personalSchedule.db.remove(self.attr('data-event-id'))
      else
        self.attr('checked', 'checked').checkboxradio('refresh')
        self.parent().find('.ui-btn-text:first').html(self.attr('data-event-dontattend-text'))
        personalSchedule.db.push(self.attr('data-event-id'))

    if personalSchedule.db.contains(eventID)
      attendCheckbox.attr('checked', 'checked').checkboxradio('refresh')
      attendCheckbox.parent().find('.ui-btn-text:first').html(attendCheckbox.attr('data-event-dontattend-text'))
    else
      attendCheckbox.removeAttr('checked').checkboxradio('refresh')
      attendCheckbox.parent().find('.ui-btn-text:first').html(attendCheckbox.attr('data-event-attend-text'))

    $.mobile.changePage(@page)

eventView = new Event()
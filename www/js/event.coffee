class Event
  @page

  _setField: (targetElement, value) ->
    targetElement.append(value)

  _resetLayout: ->
    # check for tpls within our event elements
    # if there exists a tpl element, don't remove it
    $('[data-is-event-field=1]', @page).each ->
      eventElement = $(@)
      if eventElement.find('.tpl').length
        eventElement.children(':not(.tpl)').remove()
      # there is no tpl found, simple set html to ''
      else
        eventElement.html('')

  initialize: (eventNode, options) ->
    @page = $('#event')
    @_resetLayout()

    for eventField in eventNode.children()
      fieldName = eventField.tagName
      eventField = $(eventField)

      targetElement = $("#event-#{fieldName}")
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

    $.mobile.changePage(@page, {transition : 'flow'})

event = new Event()
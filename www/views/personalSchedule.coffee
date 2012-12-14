class PersonalScheduleView
  @page

  _resetLayout: ->
    contentDiv = $('div[data-role=content]:first', @page)
    $('ul[data-role=listview]:first', contentDiv).html('')

  initialize: (eventNode, options) ->
    @page = $('#personalSchedule')
    @_resetLayout()

    eventsSorted = {}
    counter = 0
    for eventID in personalSchedule.db.getData()
      event = $(programXML.find("event[id='#{eventID}']:first"))
      roomNode = event.parent()
      dayNode = roomNode.parent()
      date = dayNode.attr('date')
      start_fetched = event.find('start:first').text()

      # ignore invalid events
      continue if not date

      dateSplitted = date.split('-')

      # event starts at 11am, put hours 0,1,2...10 at the end of the table
      start = parseFloat(start_fetched.replace(':', '.'))
      if parseInt(start) < 11
        start = start + 24

      eventsSorted[date + start * 100 + counter] =
        title: event.find('title:first').text()
        href: '#event#' + escape(dayNode.attr('index')) + '#' + escape(roomNode.attr('name')) + '#' + escape(eventID)
        start: start_fetched
        dayForUI: parseInt(dateSplitted[2]) + '. ' + helper.i18nDateFormats.monthNames[parseInt(dateSplitted[1]) - 1] # 2012-12-27 => 27. Dec

      counter = counter + 1

    contentDiv = $('div[data-role=content]:first', @page)
    listView = $('ul[data-role=listview]:first', contentDiv)
    listViewLiElementTpl = $('.tpl.element:first', contentDiv)
    listViewLiHeaderTpl = $('.tpl.header:first', contentDiv)

    lastHeaderContent = undefined
    for eventDateKey in helper.getObjKeys(eventsSorted).sort()
      event = eventsSorted[eventDateKey]

      # header
      headerContent = event.dayForUI
      if lastHeaderContent != headerContent
        _listViewLiHeaderTpl = listViewLiHeaderTpl.clone().removeClass('tpl')
        _listViewLiHeaderTpl.html(headerContent)
        listView.append(_listViewLiHeaderTpl)
        lastHeaderContent = headerContent

      # event
      _listViewLiElementTpl = listViewLiElementTpl.clone().removeClass('tpl')
      _listViewLiElementTplLink = _listViewLiElementTpl.find('a:first')
      _listViewLiElementTplLink.attr('href', event.href)
      _listViewLiElementTplLink.html(
        event.start + ' ' + event.title
      )

      listView.append(_listViewLiElementTpl)

    listView.listview('refresh')

    if counter > 0
      $('#personalSchedule-placeholder').hide()
      $('#personalSchedule-entries').show()
    else
      $('#personalSchedule-placeholder').show()
      $('#personalSchedule-entries').hide()

    $.mobile.changePage(@page)


personalScheduleView = new PersonalScheduleView()
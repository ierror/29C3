scheduleView =
  initialize: (dayNode, options) ->
    dayIndex = dayNode.attr('index')
    page = $('#schedule').clone()
    theadRow = page.find('thead tr', page)

    page_id = "schedule##{dayIndex}"
    page.attr('id', page_id)
    page.attr('data-url', page_id)

    page.attr('data-day-index', dayIndex)

    # is the request loading a schedule "day tab"?
    for roomNode in dayNode.find('room')
      roomNode = $(roomNode)
      roomName = roomNode.attr('name')
      continue if not roomName

      # add room to table header
      th = $("<th style='width=100%'>#{roomName}</th>").attr('data-is-room-column', 1)
      theadRow.append(th)

      # add room column content
      for eventNode in roomNode.find('event')
        eventNode = $(eventNode)

        duration = eventNode.find('duration:first').text()
        durationSplitted = duration.split(':')
        durationHours = durationSplitted[0]
        durationMinutes = durationSplitted[1]
        rowspan = (durationHours * 4 + durationMinutes / 15)

        eventID = eventNode.attr('id')
        eventHref = '#event#'+escape(dayIndex)+'#'+escape(roomName)+'#'+escape(eventID)

        td = $("<td id='event-#{eventID}' class='event-cell' rowspan='#{rowspan}'><a href='#{eventHref}'> "+
          eventNode.find('title:first').text()+'</a></td>').attr('data-is-event-cell', 1)

        # planning to visit this event?
        if personalSchedule.db.contains(eventID)
          td.addClass('event-attend')

        $('.timeslot-'+eventNode.find('start:first').text().replace(':', ''), page).append(td)

        td.click ->
          window.location = $(@).find('a:first').attr('href')
          return false

      $('body').append(page)



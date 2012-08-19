schedule =
  initialize: (dayNode, options) ->
    dayIndex = dayNode.attr('index')
    page = $('#schedule')
    theadRow = page.find('thead tr')

    # cleanup prev entries
    theadRow.find('th[data-is-room-column=1]').remove()
    page.find('td[data-is-event-cell=1]').remove()

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

        td = $("<td style='background-color: #d3d3d3;' rowspan='#{rowspan}'><a href='#{eventHref}'> "+
          eventNode.find('title:first').text()+'</a></td>').attr('data-is-event-cell', 1)

        $('#timeslot-'+eventNode.find('start:first').text().replace(':', '')).append(td)

    $.mobile.changePage(page)

    # chg tab active state
    $("li[data-day-index=#{dayIndex}] .link").addClass('ui-btn-active')


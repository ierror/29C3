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
      name = roomNode.attr('name')
      continue if not name

      # add room to table header
      th = $("<th style='width=100%'>#{name}</th>").attr('data-is-room-column', 1)
      theadRow.append(th)

      # add room clolumn content
      for eventNode in roomNode.find('event')
        eventNode = $(eventNode)

        duration = eventNode.find('duration:first').text()
        durationSplitted = duration.split(':')
        durationHours = durationSplitted[0]
        durationMinutes = durationSplitted[1]
        rowspan = (durationHours * 4 + durationMinutes / 15)

        td = $("<td style='background-color: #d3d3d3;' rowspan='#{rowspan}'>"+eventNode.find('title:first').text()+'</td>').attr('data-is-event-cell', 1)

        $('#timeslot-'+eventNode.find('start:first').text().replace(':', '')).append(td)

    $.mobile.changePage(page)

    # chg tab active state
    $("li[data-day-index=#{dayIndex}] .link").addClass('ui-btn-active')


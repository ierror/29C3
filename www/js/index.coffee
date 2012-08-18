class App
  @programXML

  constructor: ->
    document.addEventListener('deviceready', @deviceready(), false)

  deviceready: ->
    # build day tabs
    for dayNode in programXML.find('day')
      dayNode = $(dayNode)
      date = dayNode.attr('date')

      # 2012-12-27 => 27. Dec
      dateSplitted = date.split('-')
      dayNode.dayForUI = parseInt(dateSplitted[2]) + '. ' + helper.i18nDateFormats.monthNames[parseInt(dateSplitted[1]) - 1]

      dayTab = $('.tabs li:first').clone()
      dayIndex = dayNode.attr('index')
      dayTab.attr(
        'data-day-index': dayIndex
      )

      pageHref = "#schedule##{dayIndex}"

      # add schedule link to tab button
      a = dayTab.find('a:first')
      a.attr('href', pageHref)
      a.html(dayNode.dayForUI)

      $('.tabs').append($('<div />').append(dayTab.show()).html())

      # set active tab if current day is available event day
      if helper.formatDate(new Date(), 'yyyy-mm-dd') is date
        document.location.href = pageHref # i don't know why $.mobile.changePage does not work here...



xmlLoader = new ScheduleXMLLoader()
xmlLoader.appStartUpLoad()
programXML = xmlLoader.getXMLTree()

$(document).bind 'pagebeforechange', (event, data) ->
  if typeof data.toPage == 'string'
    parsedUrl = $.mobile.path.parseUrl(data.toPage)
    if parsedUrl.filename == 'index.html' && /^#schedule#/.test(parsedUrl.hash)
      # determine corresponding dayNode
      for dayNode in programXML.find('day')
        dayNode = $(dayNode)
        if dayNode.attr('index') == parsedUrl.hash.split('#')[2]
          schedule.initialize(dayNode, data.option)
          event.preventDefault()
          break

app = new App()

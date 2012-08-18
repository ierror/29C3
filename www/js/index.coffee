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

      a = dayTab.find('a:first')
      a.attr('href', "#schedule##{dayIndex}")
      a.html(dayNode.dayForUI)

      $('.tabs').append($('<div />').append(dayTab.show()).html())

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
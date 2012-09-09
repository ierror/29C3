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
      a.removeClass('ui-btn-active')
      a.removeClass('ui-state-persist')

      $('.tabs').append($('<div />').append(dayTab.show()).html())

      # set active tab if current day is available event day
      if helper.formatDate(new Date(), 'yyyy-mm-dd') is date
        # i don't know why $.mobile.changePage does not work here...
        document.location.href = pageHref

# prepare schedule xml
xmlLoader = new ScheduleXMLLoader()
xmlLoader.appStartUpLoad()
programXML = xmlLoader.getXMLTree()

# dynamic page content
$(document).bind 'pagebeforechange', (e, data) ->
  return if typeof data.toPage != 'string'

  parsedUrl = $.mobile.path.parseUrl(data.toPage)
  return if not parsedUrl.filename == 'index.html'

  if /^#schedule#/.test(parsedUrl.hash)
    $('li[data-day-index] .link').removeClass('ui-btn-active')

    # determine corresponding dayNode
    dayNode = $(programXML.find('day[index=' + parsedUrl.hash.split('#')[2] + ']:first'))
    scheduleView.initialize(dayNode, data.option)

    # set back link for event
    $('#event-back').attr('href', parsedUrl.href)

    e.preventDefault()

  else if /^#personalSchedule$/.test(parsedUrl.hash)
    $('li[data-day-index] .link').removeClass('ui-btn-active')

    # set back link for event
    $('#event-back').attr('href', parsedUrl.href)

    personalScheduleView.initialize()

  # #event# <day-index> # <room-name> # <event-id>
  # 0  1         2            3            4
  else if /^#event#[0-9]+#.*#[0-9]+$/.test(parsedUrl.hash)
    # determine corresponding event
    parsedUrlHash = parsedUrl.hash.split('#')

    dayNode   = $(programXML.find('day[index=' + unescape(parsedUrlHash[2]) + ']:first'))
    roomNode  = $(dayNode.find('room[name="' + unescape(parsedUrlHash[3]) + '"]:first'))
    eventNode = $(roomNode.find('event[id=' + unescape(parsedUrlHash[4]) + ']:first'))

    eventView.initialize(eventNode, data.option)
    e.preventDefault()

  else if /^#twitter/.test(parsedUrl.hash)
    twitter.authenticate()
    if not twitter.is_authenticated()
      twitter.authenticate()

    twitterView.initialize()
    e.preventDefault()

# open external links in child browser
$(document).on 'click', '.external-link', ->
  window.plugins.childBrowser.showWebPage $(@).attr('href')
  false

app = new App()

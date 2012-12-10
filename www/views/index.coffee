class App
  constructor: ->
    document.addEventListener('deviceready', @deviceready(), false)

  deviceready: ->
    ua = navigator.userAgent
    platform =
      ios: ua.match(/(iPhone|iPod|iPad)/)
      android: ua.match(/Android/)

    if platform.android
      document.write "<script src=\"lib/js/cordova-2.1.0-Android.js\"></script>"
      document.write "<script src=\"lib/js/ChildBrowser-Android.js\"></script>"
    else if platform.ios
      document.write "<script src=\"lib/js/cordova-2.1.0-iOS.js\"></script>"
      document.write "<script src=\"lib/js/ChildBrowser-iOS.js\"></script>"


    # build day tabs
    dayTab2Load = undefined
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
      if helper.formatDate(new Date(), 'yyyy-mm-dd') == date
        dayTab2Load = pageHref

      scheduleView.initialize(dayNode)

    if not dayTab2Load
      personalScheduleView.initialize()
    else
      $(document).ready ->
        $.mobile.changePage dayTab2Load


# prepare schedule xml
xmlLoader = new ScheduleXMLLoader()
xmlLoader.appStartUpLoad()
programXML = xmlLoader.getXMLTree()

personalSchedule = new PersonalSchedule()

# dynamic page content
$(document).bind 'pagebeforechange', (e, data) ->
  return if typeof data.toPage != 'string'

  parsedUrl = $.mobile.path.parseUrl(data.toPage)
  return if not parsedUrl.filename == 'index.html'

  $('body').addClass('ui-loading')
  $('a.tab').removeClass('ui-btn-active')

  if /^#schedule#/.test(parsedUrl.hash)
    # determine corresponding dayNode
    parsedUrlHash = parsedUrl.hash.split('#')
    dayNode = $(programXML.find('day[index=' + parsedUrlHash[2] + ']:first'))

    page_link = "#schedule#" + parsedUrlHash[2]
    $('body').attr('data-last-active-page', page_link)
    $('#event-back').attr('data-rel', 'back').attr('href', '')

  else if /^#personalSchedule$/.test(parsedUrl.hash)
    $('body').attr('data-last-active-page', parsedUrl.hash)
    $('#event-back').attr('data-rel', '').attr('href', '#personalSchedule')
    personalScheduleView.initialize()
    e.preventDefault()

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

  last_active_page = $('body').attr('data-last-active-page')
  if last_active_page
    $("a.tab[href='#{last_active_page}']").addClass('ui-btn-active')

  $('body').removeClass('ui-loading')

$('div[data-role="page"]').live 'pageshow', ->
  page = $(@)
  pageID = page.attr('id')
  last_scroll_pos = userconfig.getItem("last-scroll-pos-#{pageID}")
  if last_scroll_pos and $(window).scrollTop() != last_scroll_pos
    $('html, body').animate({ scrollTop: last_scroll_pos }, 'fast')

# open external links in child browser
$(document).on 'click', '.external-link', ->
  window.plugins.childBrowser.showWebPage $(@).attr('href')
  false

# fix: https://github.com/jquery/jquery-mobile/issues/3956
$(window).resize ->
  $('.ui-header').width $(window).width()
  $('.ui-footer').width $(window).width()

# remember scroll pos
$(window).bind 'scrollstop', ->
  pageID = $.mobile.activePage.attr('id')
  if pageID != 'event'
    userconfig.setItem('last-scroll-pos-' + pageID, $(window).scrollTop())

$.mobile.defaultPageTransition = 'none'

app = new App()
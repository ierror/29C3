# app config
Config = ->
  @programXMLUrl = 'http://events.ccc.de/congress/2011/Fahrplan/schedule.en.xml'
  @twitter =
    consumerKey: ''
    consumerSecret: ''
    successCallbackUrl: 'http://127.0.0.1/'
  @

config = new Config()

# some jq mobile related settings
$(document).bind 'mobileinit', ->
  $.mobile.defaultPageTransition = 'none'
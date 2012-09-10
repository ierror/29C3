# app config
Config = ->
  @programXMLUrl = 'http://events.ccc.de/congress/2011/Fahrplan/schedule.en.xml'
  @twitter =
    consumerKey: ''
    consumerSecret: ''
    successCallbackUrl: 'https://twitter.com/'
  @

config = new Config()

# some jq mobile related settings
$(document).bind 'mobileinit', ->
  $.mobile.defaultPageTransition = 'none'
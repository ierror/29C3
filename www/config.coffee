# app config
Config = ->
  @programXMLUrl = 'http://events.ccc.de/congress/2011/Fahrplan/schedule.en.xml'
  @

config = new Config()

# some jq mobile related settings
$(document).bind 'mobileinit', ->
  $.mobile.defaultPageTransition = 'none'
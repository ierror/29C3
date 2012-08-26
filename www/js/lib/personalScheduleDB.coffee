class PersonalScheduleDB
  @data

  constructor: ->
    @data = JSON.parse(userconfig.getItem('personalSchedule', '[]'))

  getData: ->
    @data

  save: ->
    userconfig.setItem('personalSchedule', JSON.stringify(@data))

  push: (eventID) ->
    eventID = parseInt(eventID)
    @data.push eventID  unless eventID in @data
    @save()

  remove: (eventID) ->
    eventIDIndex = $.inArray(parseInt(eventID), @data)
    @data.splice(eventIDIndex, 1) if eventIDIndex >= 0
    @save()

  contains: (eventID) ->
    parseInt(eventID) in @data
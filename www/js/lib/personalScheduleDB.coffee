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
    @data.splice($.inArray(parseInt(eventID), @data), 1)
    @save()

  contains: (eventID) ->
    parseInt(eventID) in @data
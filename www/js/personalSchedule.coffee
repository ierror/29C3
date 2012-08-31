class PersonalSchedule
  @db

  constructor: ->
    @db = new PersonalScheduleDB()

personalSchedule = new PersonalSchedule()

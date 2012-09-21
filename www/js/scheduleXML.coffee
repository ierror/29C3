class ScheduleXMLLoader
  loadFromServer: (programmXMLUrl, doneCallback) ->
    $.ajax(
      url: programmXMLUrl
      dataType: 'text'
      async: false
      timeout: 2000
    )
    .done (responseXML) ->
      doneCallback(responseXML)
    .error ->
      throw 'Unable to load from server'

  appStartUpLoad: ->
    # only update if schedule xml is older than 3 hours
    currentTimestamp = Math.round((new Date()).getTime() / 1000)
    lastUpdateTimestamp = userconfig.getItem('scheduleXMLLastUpdate')

    if not lastUpdateTimestamp || (currentTimestamp - lastUpdateTimestamp > 10800)
      try
      # try to load current XML from server
        @loadFromServer config.programXMLUrl, (programXML) ->
          $($.parseXML(programXML))
          userconfig.setItem('programXML', programXML)
          userconfig.setItem('scheduleXMLLastUpdate', currentTimestamp)
          alert 'Successfully updated schedule.xml from '+config.programXMLUrl
      catch e

  getXMLTree: ->
    # try to load a saved version
    programXML = userconfig.getItem 'programXML'
    xmlTree = undefined
    if not programXML
      # load from bundled schedule.xml
      @loadFromServer 'schedule.xml', (programXML) ->
        xmlTree = $($.parseXML(programXML))

    else
      xmlTree = $($.parseXML(programXML))

    xmlTree



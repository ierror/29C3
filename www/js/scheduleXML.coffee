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
      alert 'Successfully updated schedule.xml from '+programmXMLUrl
    .error ->
      throw 'Unable to load from server'

  appStartUpLoad: ->
    # only update if schedule xml is older than 3 hours
    currentTimestamp = Math.round((new Date()).getTime() / 1000)
    lastUpdateTimestamp = userconfig.getItem('schedule_xml_last_update')

    if not lastUpdateTimestamp || (currentTimestamp - lastUpdateTimestamp > 10800)
      try
      # try to load current XML from server
        @loadFromServer config.programXMLUrl, (programXML) ->
          $($.parseXML(programXML))
          userconfig.setItem('programXML', programXML)
          userconfig.setItem('schedule_xml_last_update', currentTimestamp)
      catch e

  getXMLTree: ->
    # try to load a saved version
    programXML = userconfig.getItem 'programXML'
    xmlTree = undefined
    if not programXML
      @loadFromServer 'schedule.xml', (programXML) ->
        xmlTree = $($.parseXML(programXML))

    # load from bundled schedule.xml
    else
      xmlTree = $($.parseXML(programXML))

    xmlTree



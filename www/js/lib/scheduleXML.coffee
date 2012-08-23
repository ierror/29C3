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
    try
    # try to load current XML from server
      @loadFromServer config.programXMLUrl, (programXML) ->
        $($.parseXML(programXML))
        userconfig.setItem('programXML', programXML)
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



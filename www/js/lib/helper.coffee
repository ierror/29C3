class Helper
  @i18nDateFormats

  constructor: ->
    @i18nDateFormats = @_i18nDateFormats()

  fetchAndReturnHTTURL: (url) ->
    response = undefined
    $.ajax(
      url: url
      dataType: 'text'
      async: false
      timeout: 2000
    ).done (responseInner) ->
      response = responseInner

    response

  _i18nDateFormats: ->
    dayNames: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
    monthNames: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']

helper = new Helper
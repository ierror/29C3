class Helper
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

helper = new Helper
class TwitterView
  @page

  initialize: ->
    @page = $('#twitter')
    $.mobile.changePage(@page)

twitterView = new TwitterView()
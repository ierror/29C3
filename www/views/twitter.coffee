class TwitterView
  @page

  initialize: (hashTag) ->
    @page = $('#twitter-list-view')

    tweets = twitter.getTweets(hashTag)

    # no tweets available
    if not tweets
      $.mobile.changePage(@page)

    contentDiv = $('div[data-role=content]:first', @page)
    listView = $('ul[data-role=listview]:first', contentDiv)
    liTpl = $('li.tpl:first', listView)

    for tweet in tweets
      _liTpl = liTpl.clone()

      $('.twitter-tweet:first', _liTpl).html(tweet.text)
      $('.twitter-name:first', _liTpl).html(tweet.user.screen_name)
      $('.twitter-screen-name:first', _liTpl).html(tweet.user.name)
      $('.twitter-profile-image', _liTpl).attr('src', tweet.user.profile_image_url_https)

      _liTpl.removeClass('tpl')
      listView.append(_liTpl)

    liTpl.hide()
    $.mobile.changePage(@page)


twitterView = new TwitterView()
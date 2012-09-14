class TwitterTweetbot

  authenticate: ->
    true

  isAuthenticated: ->
    true

  showSearch: (query) ->
    window.open 'tweetbot:///search?query=' + escape(query) + '&callback_url=' + escape('congress2012://')


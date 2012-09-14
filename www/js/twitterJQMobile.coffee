class TwitterJQMobile
  @accessor

  constructor: ->
    @accessor =
      consumerKey: config.twitter.consumerKey
      consumerSecret: config.twitter.consumerSecret
      serviceProvider:
        signatureMethod: 'HMAC-SHA1'
        requestTokenURL: 'http://api.twitter.com/oauth/request_token'
        userAuthorizationURL: 'https://api.twitter.com/oauth/authorize'
        accessTokenURL: 'https://api.twitter.com/oauth/access_token'

  authenticate: (sucessCallback) ->
    self = @

    userconfig.setItem('twitter_token', undefined)
    userconfig.setItem('twitter_secret_token', undefined)

    message =
      method: 'post'
      action: self.accessor.serviceProvider.requestTokenURL
      parameters: [['scope', 'http://www.google.com/m8/feeds/']]

    requestBody = OAuth.formEncode(message.parameters)
    OAuth.completeRequest message, self.accessor
    authorizationHeader = OAuth.getAuthorizationHeader('', message.parameters)
    requestToken = new XMLHttpRequest()

    requestToken.onreadystatechange = ->
      if requestToken.readyState is 4
        results = OAuth.decodeForm(requestToken.responseText)
        oauth_token = OAuth.getParameter(results, 'oauth_token')
        authorize_url = self.accessor.serviceProvider.userAuthorizationURL + '?oauth_token=' + oauth_token

        window.plugins.childBrowser.onLocationChange = (loc) ->
          if loc.indexOf(config.twitter.successCallbackUrl) > -1
            results = OAuth.decodeForm(requestToken.responseText)
            message =
              method: 'post'
              action: self.accessor.serviceProvider.accessTokenURL

            OAuth.completeRequest message,
              consumerKey: self.accessor.consumerKey
              consumerSecret: self.accessor.consumerSecret
              token: OAuth.getParameter(results, 'oauth_token')
              tokenSecret: OAuth.getParameter(results, 'oauth_token_secret')

            requestAccess = new XMLHttpRequest()
            requestAccess.onreadystatechange = receiveAccessToken = ->
              if requestAccess.readyState is 4
                params = helper.getURLVarsFromString requestAccess.responseText
                userconfig.setItem 'twitter_token', params['oauth_token']
                userconfig.setItem 'twitter_secret_token', params['oauth_token_secret']
                userconfig.setItem 'twitter_user_name', params['screen_name']
                userconfig.setItem 'twitter_user_id', params['user_id']

                window.plugins.childBrowser.close()
                sucessCallback() if sucessCallback

            requestAccess.open message.method, message.action, false
            requestAccess.setRequestHeader 'Authorization', OAuth.getAuthorizationHeader('', message.parameters)
            requestAccess.send()

        window.plugins.childBrowser.showWebPage authorize_url

    requestToken.open message.method, message.action, false
    requestToken.setRequestHeader 'Authorization', authorizationHeader
    requestToken.setRequestHeader 'Content-Type', 'application/x-www-form-urlencoded'
    requestToken.send requestBody

  isAuthenticated: ->
    userconfig.getItem('twitter_token') && userconfig.getItem('twitter_secret_token')

  getTweets: (query, count) ->
    self = @
    count = 30 if not count
    query = escape(query)

    message =
      method: 'get'
      action: "https://api.twitter.com/1.1/search/tweets.json?q=#{query}&count=#{count}&include_entities=1"

    OAuth.completeRequest message,
      consumerKey: self.accessor.consumerKey
      consumerSecret: self.accessor.consumerSecret
      token: userconfig.getItem('twitter_token')
      tokenSecret: userconfig.getItem('twitter_secret_token')

    requestAccess = new XMLHttpRequest()
    tweets = []
    requestAccess.onreadystatechange = ->
      if requestAccess.readyState is 4
        jsonResponse = JSON.parse requestAccess.responseText

        if jsonResponse.errors
          for error in jsonResponse.errors
            alert error.message
            tweets = false
        else
          tweets = jsonResponse.statuses or []

    requestAccess.open message.method, message.action, false
    requestAccess.setRequestHeader 'Authorization', OAuth.getAuthorizationHeader('', message.parameters)
    requestAccess.send()

    return tweets

  showSearch: (query) ->
    twitterView.initialize(query)
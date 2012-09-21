$('#info-reset-twitter-auth-link').click ->
  twitter.resetAuthData()
  alert 'Successfully removed twitter auth data'
  false

$('#event-use-tweetbot-checkbox').bind 'change', (event, ui) ->
  if $(@).attr('checked')
    userconfig.setItem('use-tweetbot', true)
  else
    userconfig.setItem('use-tweetbot', false)

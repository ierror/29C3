class UserConfig
  @_storageHandle
  @_keyPrefix

  constructor: ->
    @_keyPrefix = '_userconfig_'
    @_storageHandle = window.localStorage

  _buildKey: (key) ->
    @_keyPrefix + key

  setItem: (key, value) ->
    @_storageHandle.setItem(@_buildKey(key), JSON.stringify(value))

  getItem: (key, defaultValue) ->
    item = @_storageHandle.getItem(@_buildKey(key))
    if item?
      JSON.parse item
    else if defaultValue
      defaultValue

userconfig = new UserConfig()
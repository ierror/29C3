class UserConfig
  @_storageHandle
  @_keyPrefix

  constructor: ->
    @_keyPrefix = '_userconfig_'
    @_storageHandle = window.localStorage

  _buildKey: (key) ->
    @_keyPrefix + key

  setItem: (key, value) ->
    @_storageHandle.setItem(@_buildKey(key), value)

  getItem: (key) ->
    @_storageHandle.getItem(@_buildKey(key))

userconfig = new UserConfig()
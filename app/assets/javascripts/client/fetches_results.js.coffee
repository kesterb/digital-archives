@App ?= {}

class @App.FetchesResults
  constructor: ->
    @_uri = new URI()

  fetch: (resultType, page, success) ->
    @_uri.setSearch("page", page)
    $.get "/#{resultType}#{@_uri.search()}", success

  addResultType: (resultType) ->
    @_uri.addSearch("types[]", resultType)

  removeResultType: (resultType) ->
    @_uri.removeSearch("types[]", resultType)

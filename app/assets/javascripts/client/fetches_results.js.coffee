@App ?= {}

class @App.FetchesResults
  constructor: ->
    @_url = window.location.search

  fetch: (resultType, page, success) ->
    $.get "/#{resultType}#{@_url}&page=#{page}", success

  addResultType: (resultType) ->
    @_url = @_url.concat(@_resultTypeFragment(resultType))

  removeResultType: (resultType) ->
    @_url = @_url.replace(@_resultTypeFragment(resultType), "")

  _resultTypeFragment: (resultType) ->
    "&types%5B%5D=#{resultType}"

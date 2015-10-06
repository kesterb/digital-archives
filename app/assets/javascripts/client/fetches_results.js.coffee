@App ?= {}

class @App.FetchesResults
  constructor: ->
    @url = window.location.search

  addResultType: (resultType) ->
    @url = @url.concat(@_resultTypeFragment(resultType))

  removeResultType: (resultType) ->
    @url = @url.replace(@_resultTypeFragment(resultType), "")

  _resultTypeFragment: (resultType) ->
    "&types%5B%5D=#{resultType}"

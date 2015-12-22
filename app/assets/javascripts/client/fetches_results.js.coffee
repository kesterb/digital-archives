@App ?= {}

class @App.FetchesResults
  constructor: ->
    @_search = window.location.search

  fetch: (resultType, page, success) ->
    page_param = "page=#{page}"
    params = if @_search == ""
      "?#{page_param}"
    else
      "#{@_search}&#{page_param}"

    $.get "/#{resultType}#{params}", success

  addResultType: (resultType) ->
    @_search = @_search.concat(@_resultTypeFragment(resultType))

  removeResultType: (resultType) ->
    @_search = @_search.replace(@_resultTypeFragment(resultType), "")

  _resultTypeFragment: (resultType) ->
    "&types%5B%5D=#{resultType}"

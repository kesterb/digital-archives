@App ?= {}

class @App.ResultsSection
  constructor: (@_resultType, @_fetchesResults) ->
    @_element = $(".#{@_resultType}")
    @_results = @_element.find(".js-results")
    @_count = @_element.find(".file-type-count")
    @_paging = @_element.find(".paging")

    @fetch()

  fetch: (page = 1) ->
    @_results.empty() if page == 1
    @_fetchesResults.fetch @_resultType, page, @_fetchCompleted

  _fetchCompleted: (data) =>
    @_insertResults $(data)
    @_initializeLoadMore()

  _insertResults: (results) ->
    if results.data("more")
      @_loadMoreButton().data "page", results.data("page")

    @_results.append results.find("##{@_resultType}").html()
    @_count.text results.data("total-items")
    @_paging.html results.find(".paging").html()

  _initializeLoadMore: ->
    @_loadMoreButton().click (event) =>
      page = $(event.target).data("page")
      @fetch page

  _loadMoreButton: ->
    @_element.find ".js-load-more"

class @App.VideoResultsSection extends @App.ResultsSection
  _fetchCompleted: (data) =>
    super data
    VideoGrid.init()

class @App.ImageResultsSection extends @App.ResultsSection
  constructor: (resultType, fetchesResults) ->
    super resultType, fetchesResults
    @_slideshow = @_element.find(".js-slideshow")
    debugger

  _fetchCompleted: (data) =>
    super data
    @_initImageGallery()

  _insertResults: (results) ->
    super results
    debugger
    @_slideshow.append results.find("#slideshow").html()

  _initImageGallery: ->
    gallery = @_element.find("#grid-gallery")
    if gallery.length
      new CBPGridGallery(gallery.get(0))

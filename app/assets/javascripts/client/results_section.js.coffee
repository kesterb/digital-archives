@App ?= {}

class @App.ResultsSection
  constructor: (@_resultType, @_fetchesResults) ->
    @_element = $(".#{@_resultType}")
    @_loading = @_element.find(".loading")
    @_results = @_element.find(".js-results")
    @_count = @_element.find(".file-type-count")
    @_paging = @_element.find(".paging")

    @fetch()

  fetch: (page = 1) ->
    @_results.empty() if page == 1
    @_loading.removeClass("is-hidden")
    @_loadMoreButton().addClass("is-disabled")
    @_fetchesResults.fetch @_resultType, page, @_fetchCompleted

  _fetchCompleted: (data) =>
    @_insertResults $(data)
    @_initializeImagesLoadedTrigger()
    @_initializeLoadMore()

  _insertResults: (results) ->
    if results.data("more")
      @_loadMoreButton().data "page", results.data("page")

    @_results.append results.find("##{@_resultType}").html()
    @_count.text results.data("total-items")
    @_paging.html results.find(".paging").html()

  _initializeImagesLoadedTrigger: ->
    @_results.imagesLoaded @_imagesLoaded

  _imagesLoaded: =>
    @_results.find("li").removeClass("is-hidden")
    @_loadMoreButton().removeClass("is-disabled")
    @_paging.removeClass("is-hidden")
    @_loading.addClass("is-hidden")

  _initializeLoadMore: ->
    @_loadMoreButton().click (event) =>
      page = $(event.target).data("page")
      @fetch page

  _loadMoreButton: ->
    @_paging.find ".js-load-more"

class @App.FlowGridResultsSection extends @App.ResultsSection
  constructor: (resultType, fetchesResults) ->
    super(resultType, fetchesResults)
    @_grid = new App.FlowGrid @_element.find(".flow-grid")

  _fetchCompleted: (data) =>
    super data
    @_grid.relayout()

class @App.VideoResultsSection extends @App.ResultsSection
  _fetchCompleted: (data) =>
    super data
    VideoGrid.init()

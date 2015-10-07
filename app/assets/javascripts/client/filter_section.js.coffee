@App ?= {}

class @App.FilterSection
  constructor: (@_resultsSections, @_fetchesResults) ->
    @_venueList = $(".js-venue-list")
    @_resultTypeList = $(".js-type-list")
    @_yearRange = $(".js-year-range")
    @_submitButton = $("#filter-form")

    @_initializeVenueSelector()
    @_initializeResultTypeSelector()
    @_initializeYearRangeSelector()

  _initializeVenueSelector: ->
    @_venueList.imagepicker
      show_label: true
      changed: @_submitForm

  _initializeResultTypeSelector: ->
    @_resultTypeList.imagepicker
      show_label: false
      changed: @_updateSectionVisibility

  _initializeYearRangeSelector: ->
    @_yearRange.ionRangeSlider
      type: 'double'
      hide_min_max: true
      step: 1
      onFinish: @_submitForm

  _submitForm: =>
    @_submitButton.submit()

  _updateSectionVisibility: (oldTypes, newTypes) =>
    $.each @_difference(oldTypes, newTypes), (_, resultType) =>
      $('.' + resultType).removeClass 'is-active'
      @_fetchesResults.removeResultType(resultType)

    $.each @_difference(newTypes, oldTypes), (_, resultType) =>
      $('.' + resultType).addClass 'is-active'
      @_fetchesResults.addResultType(resultType)
      @_resultsSections[resultType].fetch()

  _difference: (first, second) ->
    $(first).not(second).get()

  _capitalize: (text) ->
    text.charAt(0).toUpperCase() + text.slice(1).toLowerCase()

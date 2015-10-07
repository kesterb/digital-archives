@SufiaCustomizations ?= {}

class @SufiaCustomizations.Initialize
  constructor: ->
    @_initializeProductionsSelector()
    @_initializeVenuesSelector()
    @_initializeEventTypeSelector()

  _initializeProductionsSelector: ->
    $("#generic_file_production_ids").chosen
      placeholder_text_multiple: "Select production(s)"
      search_contains: true
      single_backstroke_delete: false

  _initializeVenuesSelector: ->
    $("#generic_file_venue_ids").chosen
      placeholder_text_multiple: "Select venue(s)"
      search_contains: true
      single_backstroke_delete: false

  _initializeEventTypeSelector: ->
    $("#generic_file_event_type_id").chosen
      placeholder_text_single: "Select an event type"
      allow_single_deselect: true
      search_contains: true
      single_backstroke_delete: false

$(document).on 'ready page:load', ->
  new SufiaCustomizations.Initialize()

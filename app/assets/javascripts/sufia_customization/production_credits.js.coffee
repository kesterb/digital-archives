@SufiaCustomizations ?= {}

class @SufiaCustomizations.ProductionCredits
  constructor: ->
    @_productionIds = $("#generic_file_production_ids")
    @_venueIds = $("#generic_file_venue_ids")
    @_initializeProductionsSelector()
    @_initializeVenuesSelector()
    @_initializeEventTypeSelector()

    @_hookupVenueSelectionsUpdate()

  _initializeProductionsSelector: ->
    @_productionIds.chosen
      placeholder_text_multiple: "Select production(s)"
      search_contains: true
      single_backstroke_delete: false

  _initializeVenuesSelector: ->
    @_venueIds.chosen
      placeholder_text_multiple: "Select venue(s)"
      search_contains: true
      single_backstroke_delete: false

  _initializeEventTypeSelector: ->
    $("#generic_file_event_type_id").chosen
      placeholder_text_single: "Select an event type"
      allow_single_deselect: true
      search_contains: true
      single_backstroke_delete: false

  _hookupVenueSelectionsUpdate: ->
    @_productionIds.on "change", @_productionSelectionsChanged
    @_productionSelectionsChanged()

  _productionSelectionsChanged: =>
    ids = @_productionIds.val() ? []
    query = ("production_ids[]=#{id}" for id in ids).join("&")
    $.get "/production_credits/venues.json?#{query}", @_updateVenueChoiceEnablement

  _updateVenueChoiceEnablement: (venues) =>
    @_venueIds.find("option").attr "disabled", "disabled"
    @_venueIds.find("option[value='#{venue.id}']").removeAttr("disabled") for venue in venues
    @_venueIds.trigger("chosen:updated")

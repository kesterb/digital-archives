@SufiaCustomizations ?= {}

class @SufiaCustomizations.DateCreated
  constructor: ->
    @_yearOnly = $("#generic_file_has_year_only")
    @_dateCreated = new FormGroup $("div.generic_file_date_created")
    @_yearCreated = new FormGroup $("div.generic_file_year_created")

    @_hookupStateUpdates()

  _hookupStateUpdates: ->
    @_yearOnly.on "change", @_updateState
    @_updateState()

  _updateState: =>
    if @_yearOnly.is ":checked"
      @_switchToYearOnly()
    else
      @_switchToDate()

  _switchToYearOnly: ->
    @_dateCreated.disable()
    @_yearCreated.enable()
    @_defaultYear @_dateCreated.value()

  _defaultYear: (dateString) ->
    return if @_yearCreated.value()

    date = if dateString then new Date(dateString) else new Date()
    @_yearCreated.setValue date.getFullYear()

  _switchToDate: ->
    @_yearCreated.disable()
    @_dateCreated.enable()

class FormGroup
  constructor: (@_group) ->
    @_input = @_group.find "input"

  enable: ->
    @_input.attr "required", "required"
    @_input.attr "aria-required", "true"
    @_group.removeClass "is-hidden"

  disable: ->
    @_group.addClass "is-hidden"
    @_input.removeAttr "required"
    @_input.removeAttr "aria-required"

  value: ->
    @_input.val()

  setValue: (value) ->
    @_input.val(value)

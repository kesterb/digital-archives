@SufiaCustomizations ?= {}

@SufiaCustomizations.initialize = ->
  new SufiaCustomizations.DateCreated
  new SufiaCustomizations.ProductionCredits

$(document).on 'ready page:load', ->
  SufiaCustomizations.initialize()

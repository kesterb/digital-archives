@App ?= {}

class LayoutGrid
  # These two constants must match those in _flow-grid.scss
  GRID_MAX = 30
  CELL_MAX = 8

  GRID_MIN = GRID_MAX - CELL_MAX + 1
  COLUMNS_REGEX = ".*\\bc-(\\d+)\\b.*"

  constructor: ->
    @_row = []
    @_totalColumns = 0

  layoutCells: (cells) ->
    cells.each (_, cell) =>
      @_layoutCell $(cell)
    @_finishLastRow()

  _layoutCell: ($cell) ->
    columns = @_columnsIn($cell)
    debugger
    @_finishCurrentRow() if @_totalColumns + columns > GRID_MAX
    @_rememberCell $cell, columns

  _columnsIn: ($cell) ->
    match = $cell.attr("class").match(COLUMNS_REGEX)
    if match then parseInt(match[1], 10) else 0

  _rememberCell: ($cell, columns) ->
    @_row.push $cell
    @_totalColumns += columns

  _finishLastRow: ->
    @_totalColumns = GRID_MAX if @_totalColumns < GRID_MIN
    @_finishCurrentRow()

  _finishCurrentRow: ->
    $cell.addClass("of-#{@_totalColumns}") for $cell in @_row
    @_row = []
    @_totalColumns = 0

class @App.FlowGrid
  constructor: ->
    new LayoutGrid().layoutCells($(".grid-cell"))
#
# addDetailRowAfter = ($el) ->
#   $el.after('<div class="item-details-container"></div>')
#
# processRow = (row, totalColumns) ->
#   $el.addClass("of-#{totalColumns}") for $el in row
#   [..., last] = row
#   addDetailRowAfter(last)
#
# out = (obj) ->
#   console.log obj
#   obj
#
# $ ->
#   # removeDetailRows()
#   row = []
#   totalColumns = 0
#   nextCellId = 1
#   $(".flow-grid [class*= 'c-']").each () ->
#     columns = parseInt $(this).attr("class").split("-").pop(), 10
#     if totalColumns + columns > GRID_MAX
#       processRow(row, totalColumns)
#       row = []
#       totalColumns = 0
#     row.push $(this)
#     $(this).find('.grid-item').data('cell-id', nextCellId++)
#     totalColumns += columns
#   totalColumns = GRID_MAX if totalColumns < GRID_MAX - CELL_MAX + 1
#   processRow(row, totalColumns)
#
#   $('.grid-item').on 'click', ->
#     $container = $(this).parent().nextAll('.item-details-container').first()
#     isCurrent = out($(this).data('cell-id')) == out($container.data('currentCellId'))
#     $('.item-details-container').removeClass('is-expanded').data('currentCellId', null)
#     return if out(isCurrent)
#     $container.empty()
#     $(this).find('.item-details').clone().appendTo($container)
#     $container.addClass('is-expanded').data('currentCellId', $(this).data('cell-id'))

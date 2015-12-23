@App ?= {}

class @App.FlowGrid
  CELL_CLASS = ".grid-cell"

  constructor: (@_element) ->
    @_initializeCellClickHandler()

  relayout: ->
    @_deselectAllCells()
    @_layoutGrid()

  _initializeCellClickHandler: ->
    @_element.on "click", CELL_CLASS, (event) =>
      @_cellClicked $(event.currentTarget)

  _layoutGrid: ->
    new LayoutGrid().layoutCells(@_cells())

  _cellClicked: ($cell) ->
    if $cell.hasClass("is-selected")
      $cell.removeClass("is-selected")
    else
      @_deselectAllCells()
      $cell.addClass("is-selected")

  _deselectAllCells: ->
    @_cells().removeClass("is-selected")

  _cells: ->
    @_element.find(CELL_CLASS)

#   $('.grid-item').on 'click', ->
#     $container = $(this).parent().nextAll('.item-details-container').first()
#     isCurrent = out($(this).data('cell-id')) == out($container.data('currentCellId'))
#     $('.item-details-container').removeClass('is-expanded').data('currentCellId', null)
#     return if out(isCurrent)
#     $container.empty()
#     $(this).find('.item-details').clone().appendTo($container)
#     $container.addClass('is-expanded').data('currentCellId', $(this).data('cell-id'))



class LayoutGrid
  # These two constants must match those in _flow-grid.scss
  GRID_MAX = 30
  CELL_MAX = 8

  GRID_MIN = GRID_MAX - CELL_MAX + 1
  COLUMNS_REGEX = ".*\\bc-(\\d+)\\b.*"

  constructor: ->
    @_startNewRow()

  layoutCells: (cells) ->
    @_resetLayout(cells)
    cells.each (_, cell) =>
      @_layoutCell $(cell)
    @_finishLastRow()

  _resetLayout: (cells) ->
    @_removeDetailRows()
    @_removeTotalColumnClasses(cells)

  _layoutCell: ($cell) ->
    columns = @_columnsIn($cell)
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
    @_addTotalColumnClasses($cell) for $cell in @_row
    @_addDetailRowAfter(@_row)
    @_startNewRow()

  _startNewRow: ->
    @_row = []
    @_totalColumns = 0

  _addTotalColumnClasses: ($cell) ->
    $cell.addClass("of-#{@_totalColumns}")

  _removeTotalColumnClasses: (cells) ->
    cells.removeClass (_, classNames) ->
      classNames.split(/\s+/).filter((name) ->
        name.match(/of-\d+/)
      ).join(' ')

  _addDetailRowAfter: (row) ->
    [..., last] = row
    last.after('<div class="cell-details-container"></div>')

  _removeDetailRows: ->
    $(".cell-details-container").remove()

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

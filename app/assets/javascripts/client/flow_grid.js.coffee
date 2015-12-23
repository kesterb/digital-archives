@App ?= {}

class @App.FlowGrid
  CELL_CLASS = ".grid-cell"
  DETAILS_CONTAINER_CLASS = ".cell-details-container"

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
    @_collapseAllDetailContainers()
    if @_isCellSelected($cell)
      @_deselectCell($cell)
    else
      @_deselectAllCells()
      @_selectCell($cell)
      @_showCellDetails($cell)

  _isCellSelected: ($cell) ->
    $cell.hasClass("is-selected")

  _selectCell: ($cell) ->
    $cell.addClass("is-selected")

  _deselectCell: ($cell) ->
    $cell.removeClass("is-selected")

  _deselectAllCells: ->
    @_cells().removeClass("is-selected")

  _showCellDetails: ($cell) ->
    $container = @_detailContainerForCell($cell)
    @_addCellDetailsToContainer($cell, $container)
    @_expandDetailContainer($container)

  _detailContainerForCell: ($cell) ->
    $cell.nextAll(DETAILS_CONTAINER_CLASS).first()

  _addCellDetailsToContainer: ($cell, $container) ->
    $container.empty()
    $cell.find(".cell-details").clone().appendTo($container)

  _expandDetailContainer: ($container) ->
    $container.addClass("is-expanded")

  _collapseAllDetailContainers: ->
    @_element.find(DETAILS_CONTAINER_CLASS).removeClass("is-expanded")

  _cells: ->
    @_element.find(CELL_CLASS)


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
    last.after('<div class="cell-details-container"></div>') if last

  _removeDetailRows: ->
    $(".cell-details-container").remove()

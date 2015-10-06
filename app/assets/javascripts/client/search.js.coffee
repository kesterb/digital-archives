initLoadMoreArticles = ->
  $('.js-load-more-articles').click ->
    page = $(this).data('page')
    window.fetchArticles page

initLoadMoreVideos = ->
  $('.js-load-more-videos').click ->
    page = $(this).data('page')
    window.fetchVideos page

initLoadMoreAudios = ->
  $('.js-load-more-audios').click ->
    page = $(this).data('page')
    window.fetchAudios page

initLoadMoreImages = ->
  $('.js-load-more-images').click ->
    page = $(this).data('page')
    window.fetchImages page

initImageGallery = ->
  gallery = $('#grid-gallery')
  if gallery.length
    new CBPGridGallery(gallery.get(0))

@fetchAudios = (page) ->
  $.get '/audios?' + @fetchesResults.url + '&page=' + page, (data) ->
    if $(data).data('more') == true
      $('.js-load-more-audios').data 'page', $(data).data('page')
    if page == 1
      $('.audios-grid ul').html $(data).find('#audios').html()
    else
      $('.audios-grid ul').append $(data).find('#audios').html()
    $('.audios .file-type-count').text $(data).data('total-items')
    $('.audios .paging').html $(data).find('.paging').html()
    initLoadMoreAudios()

@fetchArticles = (page) ->
  $.get '/articles?' + @fetchesResults.url + '&page=' + page, (data) ->
    if $(data).data('more') == true
      $('.js-load-more-articles').data 'page', $(data).data('page')
    if page == 1
      $('.articles .card-grid ul').html $(data).find('#articles').html()
    else
      $('.articles .card-grid ul').append $(data).find('#articles').html()
    $('.articles .file-type-count').text $(data).data('total-items')
    $('.articles .paging').html $(data).find('.paging').html()
    initLoadMoreArticles()

@fetchVideos = (page) ->
  $.get '/videos?' + @fetchesResults.url + '&page=' + page, (data) ->
    if $(data).data('more') == true
      $('.js-load-more-videos').data 'page', $(data).data('page')
    if page == 1
      $('.videos-grid').html $(data).find('#videos').html()
    else
      $('.videos-grid').append $(data).find('#videos').html()
    $('.videos .file-type-count').text $(data).data('total-items')
    $('.videos .paging').html $(data).find('.paging').html()
    VideoGrid.init()
    initLoadMoreVideos()

@fetchImages = (page) ->
  $.get '/images?' + @fetchesResults.url + '&page=' + page, (data) ->
    if $(data).data('more') == true
      $('.js-load-more-images').data 'page', $(data).data('page')
    if page == 1
      $('.images .slideshow ul').html $(data).find('#slideshow').html()
      $('.images .card-grid').html $(data).find('#thumbnails').html()
    else
      $('.images .slideshow ul').append $(data).find('#slideshow').html()
      $('.images .card-grid').append $(data).find('#thumbnails').html()
    $('.images .file-type-count').text $(data).data('total-items')
    $('.images .paging').html $(data).find('.paging').html()
    initImageGallery()
    initLoadMoreImages()

capitalize = (text) ->
  text.charAt(0).toUpperCase() + text.slice(1).toLowerCase()

difference = (first, second) ->
  $(first).not(second).get()

updateSectionVisibility = (oldTypes, newTypes) ->
  $.each difference(oldTypes, newTypes), (_, resultType) ->
    $('.' + resultType).removeClass 'is-active'
    window.fetchesResults.removeResultType(resultType)

  $.each difference(newTypes, oldTypes), (_, resultType) ->
    $('.' + resultType).addClass 'is-active'
    window.fetchesResults.addResultType(resultType)
    window['fetch' + capitalize(resultType)] 1

@fetchesResults = new @App.FetchesResults

$ ->
  $('.js-venue-list').imagepicker
    show_label: true
    changed: ->
      $('#filter-form').submit()

  $('.js-type-list').imagepicker
    show_label: false
    changed: updateSectionVisibility
  $('.js-year-range').ionRangeSlider
    type: 'double'
    hide_min_max: true
    step: 1
    onFinish: ->
      $('#filter-form').submit()

  window.fetchImages 1
  window.fetchVideos 1
  window.fetchAudios 1
  window.fetchArticles 1

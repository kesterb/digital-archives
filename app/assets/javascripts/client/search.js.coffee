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
  @fetchesResults.fetch "audios", page, (data) ->
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
  @fetchesResults.fetch "articles", page, (data) ->
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
  @fetchesResults.fetch "videos", page, (data) ->
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
  @fetchesResults.fetch "images", page, (data) ->
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

@fetchesResults = new @App.FetchesResults

$ ->
  new window.App.FilterSection(window.fetchesResults)
  window.fetchImages 1
  window.fetchVideos 1
  window.fetchAudios 1
  window.fetchArticles 1

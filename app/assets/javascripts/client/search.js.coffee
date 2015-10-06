initLoadMoreArticles = ->
  $('.articles .js-load-more').click ->
    page = $(this).data('page')
    window.fetchArticles page

initLoadMoreVideos = ->
  $('.videos .js-load-more').click ->
    page = $(this).data('page')
    window.fetchVideos page

initLoadMoreAudios = ->
  $('.audios .js-load-more').click ->
    page = $(this).data('page')
    window.fetchAudios page

initLoadMoreImages = ->
  $('.images .js-load-more').click ->
    page = $(this).data('page')
    window.fetchImages page

initImageGallery = ->
  gallery = $('#grid-gallery')
  if gallery.length
    new CBPGridGallery(gallery.get(0))

@fetchAudios = (page) ->
  @fetchesResults.fetch "audios", page, (data) ->
    if $(data).data('more') == true
      $('.audios .js-load-more').data 'page', $(data).data('page')
    if page == 1
      $('.audios .js-results').html $(data).find('#audios').html()
    else
      $('.audios .js-results').append $(data).find('#audios').html()
    $('.audios .file-type-count').text $(data).data('total-items')
    $('.audios .paging').html $(data).find('.paging').html()
    initLoadMoreAudios()

@fetchArticles = (page) ->
  @fetchesResults.fetch "articles", page, (data) ->
    if $(data).data('more') == true
      $('.articles .js-load-more').data 'page', $(data).data('page')
    if page == 1
      $('.articles .js-results').html $(data).find('#articles').html()
    else
      $('.articles .js-results').append $(data).find('#articles').html()
    $('.articles .file-type-count').text $(data).data('total-items')
    $('.articles .paging').html $(data).find('.paging').html()
    initLoadMoreArticles()

@fetchVideos = (page) ->
  @fetchesResults.fetch "videos", page, (data) ->
    if $(data).data('more') == true
      $('.videos .js-load-more').data 'page', $(data).data('page')
    if page == 1
      $('.videos .js-results').html $(data).find('#videos').html()
    else
      $('.videos .js-results').append $(data).find('#videos').html()
    $('.videos .file-type-count').text $(data).data('total-items')
    $('.videos .paging').html $(data).find('.paging').html()
    VideoGrid.init()
    initLoadMoreVideos()

@fetchImages = (page) ->
  @fetchesResults.fetch "images", page, (data) ->
    if $(data).data('more') == true
      $('.images .js-load-more').data 'page', $(data).data('page')
    if page == 1
      $('.images .js-slideshow').html $(data).find('#slideshow').html()
      $('.images .js-results').html $(data).find('#images').html()
    else
      $('.images .js-slideshow').append $(data).find('#slideshow').html()
      $('.images .js-results').append $(data).find('#images').html()
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

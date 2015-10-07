$ ->
  fetchesResults = new window.App.FetchesResults
  resultsSections =
    articles: new window.App.ResultsSection("articles", fetchesResults)
    audios: new window.App.ResultsSection("audios", fetchesResults)
    images: new window.App.ImageResultsSection("images", fetchesResults)
    videos: new window.App.VideoResultsSection("videos", fetchesResults)
  new window.App.FilterSection(resultsSections, fetchesResults)

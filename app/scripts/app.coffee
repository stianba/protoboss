do (window) ->
  class App
    constructor: (name) ->
      @name = name

  window.App = App


console.log window.App
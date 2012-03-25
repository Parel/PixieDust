TitleScreen = (I={}) ->
  self = TextScreen(I)

  self.bind 'update', ->
    engine.nextLevel() if justPressed.any

  self.bind "overlay", (canvas) ->
    self.centerText canvas, App.name

    self.centerText canvas, ""

  return self

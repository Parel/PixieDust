###*
This module clears or fills the canvas before drawing the scene.

@name Clear
@fieldOf Engine
@module
@param {Object} I Instance variables
@param {Object} self Reference to the engine
###
Engine.Levels = (I, self) ->
  Object.reverseMerge I,
    levels: []
    currentLevel: -1
    currentLevelName: null

  I.transitioning = false

  loadLevel = (level) ->
    unless I.transitioning
      I.transitioning = true

      levelState = LevelState
        level: level

      I.currentLevelName = level
      engine.setState levelState

  nextLevel: ->
    unless I.transitioning
      I.currentLevel += 1

      if level = I.levels[I.currentLevel]
        loadLevel level
      else
        engine.setState GameOver()

  goToLevel: (level) ->
    #TODO Handle integer levels?
    loadLevel level

  reloadLevel: ->
    loadLevel I.currentLevelName

###*
The `Clampable` module provides helper methods to clamp object properties. This module is included by default in `GameObject`

    player = GameObject
      x: 40
      y: 30

    player.include Clampable

@name Clampable
@module
@constructor
@param {Object} I Instance variables
@param {Core} self Reference to including object
###
Clampable = (I={}, self) ->
  Object.reverseMerge I,
    clampData: {}

  self.bind "afterUpdate", ->
    for property, data of I.clampData
      I[property] = I[property].clamp(data.min, data.max)

  ###*
  Keep an objects attributes within a given range.

      # Player's health will be within [0, 100] at the end of every update
      player.clamp
        health:
          min: 0
          max: 100
    
      # Score can only be positive
      player.clamp
        score:
          min: 0

  @name clamp
  @methodOf Clampable#
  @param {Object} data
  ###
  clamp: (data) ->
    Object.extend(I.clampData, data)

  ###*
  Helper to clamp the `x` and `y` properties of the object to be within a given bounds.

  @name clampToBounds
  @methodOf Clampable#
  @param {Rectangle} [bounds] The bounds to clamp the object's position within. Defaults to the app size if none given. 
  ###
  clampToBounds: (bounds) ->
    bounds ||= Rectangle x: 0, y: 0, width: App.width, height: App.height
    
    self.clamp
      x:
        min: bounds.x + I.width/2
        max: bounds.width - I.width/2
      y:
        min: bounds.y + I.height/2
        max: bounds.height - I.height/2

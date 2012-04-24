###*
The <code>Tween</code> module provides a method to tween object properties. 

@name Tween
@module
@constructor
@param {Object} I Instance variables
@param {Core} self Reference to including object
###
Tween = (I={}, self) ->
  Object.reverseMerge I,
    activeTweens: {}

  # Add events and methods here
  self.bind "update", ->
    for property, data of I.activeTweens
      I[property] = 10

      
  tween: (duration, properties) ->
    for property, target of properties
      activeTweens[property] =
        target: target
        start: I[property]
        easing: "linear"
        s

###*
The Expirable module deactives a <code>GameObject</code> after a specified duration.
If a duration is specified the object will update that many times. If -1 is
specified the object will have an unlimited duration.

<code><pre>
enemy = GameObject
  x: 50
  y: 30
  duration: 5

enemy.include(Durable)

enemy.I.active
# => true

5.times ->
  enemy.update()

enemy.I.active
# => false
</pre></code>

@name Durable
@module
@constructor
@param {Object} I Instance variables
@param {Core} self Reference to including object
###
Expirable = (I, self) ->
  Object.reverseMerge I,
    duration: -1
    alpha: 1
    fadeOut: false
    
  startingAlpha = I.alpha

  self.bind "update", ->
    if I.fadeOut
      I.alpha = startingAlpha * (1 - ((I.age + 1) / I.duration))  
      
    if I.duration != -1 && I.age + 1 >= I.duration
      I.active = false

  return {}

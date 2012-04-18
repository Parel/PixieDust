###*
The Controllable module adds simple movement
when up, down, left, or right are held.

<code><pre>
  # create a player and include Controllable
  player = GameObject
    includedModules: ["Controllable"]
    width: 5
    height: 17
    x: 15
    y: 30
    speed:  2

  # hold the left arrow key, then
  # update the player
  player.update()

  # the player is moved left according to his speed
  player.I.x
  # => 13
</pre></code>

@name Controllable
@module
@constructor
@param {Object} I Instance variables
@param {Core} self Reference to including object
###
Controllable = (I={}, self) ->
  Object.reverseMerge I,
    facing: Point(1, 0)
    speed: 1
    velocity: Point(0, 0)

  self.bind "update", ->
    I.velocity.x = 0
    I.velocity.y = 0
    
    if keydown.left
      I.velocity.x = -1

    if keydown.right
      I.velocity.x = 1

    if keydown.up
      I.velocity.y = -1

    if keydown.down
      I.velocity.y = 1
      
    I.velocity = I.velocity.scale(I.speed)

  movement: ->
    I.velocity.x = 0
    I.velocity.y = 0

    if keydown.left
      I.velocity.x = -1

    if keydown.right
      I.velocity.x = 1

    if keydown.up
      I.velocity..y = -1

    if keydown.down
      I.velocity.y = 1

    I.velocity = I.velocity.norm()

    I.velocity = I.velocity.scale(I.speed)
    unless p.equal(Point.ZERO)
      I.facing = p
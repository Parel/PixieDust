###*
The TimedEvents module is used to provide basic data about the
location and dimensions of the including object. This module is included
by default in <code>GameObject</code>.

<code><pre>
player = Core
  x: 10
  y: 50
  width: 20
  height: 20
  other: "stuff"
  more: "properties"

player.position()
# => Uncaught TypeError: Object has no method 'position'

player.include(Bounded)

# now player has all the methods provided by this module
player.position()
# => {x: 10, y: 50}
</pre></code>

@see GameObject

Bounded module
@name Bounded
@module
@constructor
@param {Object} I Instance variables
@param {Core} self Reference to including object
###
TimedEvents = (I={}) ->
  every: (n, fn) ->
    if I.age.mod(n) is 0
      fn()

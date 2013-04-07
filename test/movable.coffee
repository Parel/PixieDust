module "Movable"

test "should update velocity", ->
  particle = GameObject
    velocity: Point(1, 2)
    x: 50
    y: 50

  particle.update(1)

  equals particle.I.x, 51, "x position updated according to velocity"
  equals particle.I.y, 52, "y position updated according to velocity"

test "should not exceed max speed", ->
  particle = GameObject
    velocity: Point(5, 5)
    acceleration: Point(1, 1)
    maxSpeed: 10

  20.times ->
    particle.update(1)

  ok particle.I.velocity.magnitude() <= particle.I.maxSpeed, "magnitude of the velocity should not exceed maxSpeed"

test "should be able to get velocity", ->
  object = GameObject()

  ok object.velocity()

test "should be able to get acceleration", ->
  object = GameObject()

  ok object.acceleration()

# TODO fix me
#test "should increase velocity according to acceleration", ->
#  particle = GameObject
#    velocity: Point(7, 4)
#    acceleration: Point(1, -0.3)
#
#    particle.update()
#
#  equals particle.I.velocity.x, 11
#  equals particle.I.velocity.y, 2.8

module()
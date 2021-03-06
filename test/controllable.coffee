module "Controllable"

# sets up player object before each test
QUnit.testStart = ->
  window.player = GameObject
    x: 10
    y: 20
    width: 10
    height: 20
    speed: 3

  player.include Controllable   

  # Mock the keydown object
  window.keydown = {}

test "should update velocity while left is held", ->  
  window.keydown.left = true

  player.update()

  equals player.I.velocity.x, -3

  window.keydown.left = false

  player.update()
  
  equals player.I.velocity.x, 0

test "should move player right while key is pressed", ->
  window.keydown.right = true

  player.update()

  equals player.I.velocity.x, 3

  window.keydown.right = false

  player.update()
  
  equals player.I.velocity.x, 0

test "should move player up while key is pressed", ->
  window.keydown.up = true

  player.update()

  equals player.I.velocity.y, -3

  window.keydown.up = false

  player.update()
  
  equals player.I.velocity.y, 0

test "should move player down while key is pressed", ->
  window.keydown.down = true

  player.update()

  equals player.I.velocity.y, 3

  window.keydown.down = false
  
  player.update()

  equals player.I.velocity.y, 0
  
test "should handle moving diagonally", ->
  window.keydown.left = true
  window.keydown.up = true
  
  player.update()
  
  equals player.I.velocity.x, Point(-1, -1).norm().x * player.I.speed
  equals player.I.velocity.y, Point(-1, -1).norm().y * player.I.speed

test "should handle tracking facing direction diagonally", ->
  window.keydown.left = true
  window.keydown.up = true
  
  player.update()
  
  equals player.I.facing.x, Point(-1, -1).norm().x
  equals player.I.facing.y, Point(-1, -1).norm().y  
  
  window.keydown.left = false
  window.keydown.up = false
  
  equals player.I.facing.x, Point(-1, -1).norm().x
  equals player.I.facing.y, Point(-1, -1).norm().y  
  
test "should correctly track facing direction", ->
  ok player.I.facing.equal(Point(1, 0))
  
  window.keydown.left = true
  
  player.update()
  
  ok player.I.facing.equal(Point(-1, 0))
  
  window.keydown.left = false
  
  player.update()
  
  ok player.I.facing.equal(Point(-1, 0))

module()
module "ActiveBounds"

App = {}

App.width = 640
App.height = 480

test "should not be destroyed when inside activeBounds", ->
  obj = GameObject
    x: 50
    y: 50
    width: 32
    height: 32
    
  obj.include ActiveBou

test "should remove objects outside of activeBounds", 2, ->
  obj = GameObject
    x: 50
    y: 50
    width: 32
    height: 32

  obj.include(ActiveBounds)

  destroySpy = false

  obj.bind 'destroy', ->
    destroySpy = true

  obj.I.x = 10000
  obj.I.y = 50

  obj.update()

  ok destroySpy, 'obj should be destroyed when it goes outside the x bounds'

  obj2 = GameObject
    x: 100
    y: 250
    width: 16
    height: 26

  obj2.include(ActiveBounds)

  destroySpy = false

  obj2.bind 'destroy', ->
    destroySpy = true

  obj2.I.x = 100
  obj2.I.y = 50000

  obj2.update()

  ok destroySpy, 'obj2 should be destroyed when it goes outside the y bounds'

module()

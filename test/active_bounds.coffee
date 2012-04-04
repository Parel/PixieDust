module "ActiveBounds"

test "should remove objects outside of activeBounds", ->
  obj = GameObject
    x: 50
    y: 50
    width: 32
    height: 32

  obj.include(ActiveBounds)

  destroySpy = false

  obj.bind 'destroy', ->
    destroySpy = true



module()

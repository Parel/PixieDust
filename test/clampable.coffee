module "Clampable"

test "testing for equality", ->
  o = GameObject
    x: 1500

  max = 100

  o.clamp
    x:
      min: 0
      max: max

  o.update()

  equals o.I.x, max

module()
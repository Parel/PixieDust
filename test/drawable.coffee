module "Drawable"

test "should apply hflip and vflip transformations", ->
  object = GameObject
    hflip: true

  transform = object.transform()

  equal transform.a, Matrix.HORIZONTAL_FLIP.a
  equal transform.b, Matrix.HORIZONTAL_FLIP.b
  equal transform.c, Matrix.HORIZONTAL_FLIP.c
  equal transform.d, Matrix.HORIZONTAL_FLIP.d

  object.I.hflip = false
  object.I.vflip = true

  transform = object.transform()

  equal transform.a, Matrix.VERTICAL_FLIP.a
  equal transform.b, Matrix.VERTICAL_FLIP.b
  equal transform.c, Matrix.VERTICAL_FLIP.c
  equal transform.d, Matrix.VERTICAL_FLIP.d

test "alpha", ->
  object = GameObject()

  equal object.I.alpha, 1

  object2 = GameObject
    alpha: 0.5

  equal object2.I.alpha, 0.5

test "scale", ->
  object = GameObject()

  transform = object.transform()

  object = GameObject()

module()


module "Color2"

test "r, g, b default to 0, a defaults to 1", ->
  color = Color2()

  equal color.r, 0
  equal color.g, 0
  equal color.b, 0
  equal color.a, 1

test "accepts a single array of length 3", ->
  color = Color2([255, 1, 2])

  equal color.r, 255
  equal color.g, 1
  equal color.b, 2

test "accepts a single array of length 4", ->
  color = Color2([255, 4, 3, 0.8])

  equal color.r, 255
  equal color.g, 4
  equal color.b, 3
  equal color.a, 0.8

test "accepts an array of length 3 as the first argument and an alpha value as the second", ->
  color = Color2([100, 5, 3], 0.4)

  equal color.r, 100
  equal color.g, 5
  equal color.b, 3
  equal color.a, 0.4

test "accepts an array of length 4 as the first argument and an alpha value. The alpha value passed as the second argument overrides the alpha in the array", ->
  color = Color2([4, 20, 90, 0.1], 0.6)

  equal color.r, 4
  equal color.g, 20
  equal color.b, 90
  equal color.a, 0.6

test "accepts an rgb string as the first argument and an alpha value as the second", ->
  color = Color2('rgb(255, 40, 30)', 0.4)

  equal color.r, 255
  equal color.g, 40
  equal color.b, 30
  equal color.a, 0.4

test "accepts an rgba string as the first argument and an alpha value as the second. The alpha value takes precedence over the alpha from the rgba string", ->
  color = Color2('rgba(30, 20, 15, 0.8)', 0.35)

  equal color.r, 30
  equal color.g, 20
  equal color.b, 15
  equal color.a, 0.35

test "accepts an hsl string as the first argument and an alpha value as the second", ->
  color = Color2('hsl(63, 0.4, 0.3)', 0.21)

  equal color.r.round(), 104
  equal color.g.round(), 107
  equal color.b.round(), 46
  equal color.a, 0.21

test "accepts an hsla string as the first argument and an alpha value as the second. The alpha value takes precedence over the hsla string alpha value", ->
  color = Color2('hsla(45, 0.3, 0.5, 0.1)', 0.47)

  equal color.r.round(), 166
  equal color.g.round(), 147
  equal color.b.round(), 89
  equal color.a, 0.47

test "accepts hex value of length 3 as first argument and alpha value as second argument", ->
  color = Color2('#ff0', 0.5)

  equal color.r, 255
  equal color.g, 255
  equal color.b, 0
  equal color.a, 0.5 

test "accepts hex value of length 4 as first argument and alpha value as second argument. The alpha value takes precedence over the alpha from the hex string.", ->
  color = Color2('#ef3c', 0.3)

  equal color.r, 238
  equal color.g, 255
  equal color.b, 51
  equal color.a, 0.3

test "accepts hex value of length 6 as first argument and alpha value as second argument", ->
  color = Color2('#de34ab', 0.27)

  equal color.r, 222
  equal color.g, 52
  equal color.b, 171
  equal color.a, 0.27 

test "accepts hex value of length 8 as first argument and alpha value as second argument. Alpha value takes precedence over hex alpha.", ->
  color = Color2('#ab45cd', 0.59)

  equal color.r, 171
  equal color.g, 69
  equal color.b, 205
  equal color.a, 0.59

test "accepts hex string of length 3", ->
  color = Color2('#df2')

  equal color.r, 221
  equal color.g, 255
  equal color.b, 34
  equal color.a, 1.0

test "accepts hex string of length 4", ->
  color = Color2('#c987')

  equal color.r, 204
  equal color.g, 153
  equal color.b, 136
  equal color.a.toFixed(2), 0.47

test "accepts hex string of length 6", ->
  color = Color2('#cdef12')

  equal color.r, 205
  equal color.g, 239
  equal color.b, 18
  equal color.a, 1.0

test "accepts hex string of length 8", ->  
  color = Color2('#ef1234af')

  equal color.r, 239
  equal color.g, 18
  equal color.b, 52
  equal color.a.toFixed(2), 0.69

test "accepts 3 numeric values", ->
  color = Color2(34, 54, 39)

  equal color.r, 34
  equal color.g, 54
  equal color.b, 39
  equal color.a, 1.0

module()


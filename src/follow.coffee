Follow = (I={}, self) ->
  Object.reverseMerge I,
    velocity: Point(0, 0)



  self.bind "update", ->
    I.velocity = player.position().subtract(self.position()).norm().scale(5)

  return self

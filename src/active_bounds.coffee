ActiveBounds = (I={}, self) ->
  Object.reverseMerge I,
    x: 0
    y: 0
    width: 8
    height: 8
    activeBounds: Rectangle
      x: 0
      y: 0
      width: App.width
      height: App.height

  self.bind 'update', ->
    self.destroy() unless I.activeBounds.left <= I.x <= I.activeBounds.right
    self.destroy() unless I.activeBounds.top <= I.y <= I.activeBounds.bottom
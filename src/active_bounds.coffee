ActiveBounds = (I={}, self) ->
  Object.reverseMerge I,
    x: 0
    y: 0
    width: 8
    height: 8
    activeBounds: Rectangle(0, 0, App.width, App.height)
    
  log I.activeBounds

  self.bind 'update', ->
    self.destroy() unless I.activeBounds.left <= I.x <= I.activeBounds.right
    self.destroy() unless I.activeBounds.top <= I.y <= I.activeBounds.bottom
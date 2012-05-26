Camera = (I={}) ->
  Object.reverseMerge I,
    cameraBounds: Rectangle # World Coordinates
      x: 0
      y: 0
      width: App.width
      height: App.height
    screen: Rectangle # Screen Coordinates
      x: 0
      y: 0
      width: App.width
      height: App.height
    deadzone: Point(0, 0) # Screen Coordinates
    zoom: 1
    transform: Matrix()
    x: App.width/2 # World Coordinates
    y: App.height/2 # World Coordinates
    velocity: Point.ZERO
    maxSpeed: 25
    t90: 2 # Time in seconds for camera to move 90% of the way to the target

  currentType = "centered"
  currentObject = null

  objectFilters = []
  transformFilters = []

  focusOn = (object) ->
    dt = 1 / 30 # TODO: Use engine FPS
    dampingFactor = 2

    #TODO: Different t90 value inside deadzone?

    c = dt * 3.75 / I.t90
    if c >= 1
      # Spring is configured to be too intense, just snap to target
      self.position(target)
      I.velocity = Point.ZERO
    else
      objectCenter = object.center()
  
      target = objectCenter

      delta = target.subtract(self.position())

      force = delta.subtract(I.velocity.scale(dampingFactor))
      self.changePosition(I.velocity.scale(c).clamp(I.maxSpeed))
      I.velocity = I.velocity.add(force.scale(c))

  followTypes =
    centered: (object) ->              
      I.deadzone = Point(0, 0)

      focusOn(object)

    topdown: (object) ->
      helper = Math.max(I.screen.width, I.screen.height) / 4

      I.deadzone = Point(helper, helper) 

      focusOn(object)

    platformer: (object) ->
      width = I.screen.width / 8
      height = I.screen.height / 3

      I.deadzone = Point(width, height)

      focusOn(object)

  self = Core(I).extend
    follow: (object, type="centered") ->
      currentObject = object
      currentType = type

    objectFilterChain: (fn) ->
      objectFilters.push fn

    transformFilterChain: (fn) ->
      transformFilters.push fn

  self.attrAccessor "transform"

  self.bind "afterUpdate", ->
    if currentObject
      followTypes[currentType](currentObject)

    # Hard clamp camera to world bounds
    I.x = I.x.clamp(I.cameraBounds.left + I.screen.width/2, I.cameraBounds.right - I.screen.width/2)
    I.y = I.y.clamp(I.cameraBounds.top + I.screen.height/2, I.cameraBounds.bottom - I.screen.height/2)

    I.transform = Matrix.translate(-I.x, -I.y)

  self.bind "draw", (canvas, objects) ->
    # Move to correct screen coordinates
    canvas.withTransform Matrix.translate(I.screen.x, I.screen.y), (canvas) ->
      canvas.clip(0, 0, I.screen.width, I.screen.height)

      objects = objectFilters.pipeline(objects)
      transform = transformFilters.pipeline(self.transform().copy())

      canvas.withTransform Matrix.translation(I.screen.width/2, I.screen.height/2), (canvas) ->
        canvas.withTransform transform, (canvas) ->
          self.trigger "beforeDraw", canvas
          objects.invoke "draw", canvas

      self.trigger 'flash', canvas

  self.bind "overlay", (canvas, objects) ->
    canvas.withTransform Matrix.translate(I.screen.x, I.screen.y), (canvas) ->
      canvas.clip(0, 0, I.screen.width, I.screen.height)
      objects = objectFilters.pipeline(objects)

      objects.invoke "trigger", "overlay", canvas

  self.include "Bounded"

  # The order of theses includes is important for
  # the way in wich they modify the camera view transform

  for moduleName in Camera.defaultModules
    self.include "Camera.#{moduleName}"

  return self

Camera.defaultModules = [
  "ZSort"
  "Zoom"
  "Rotate"
  "Shake"
  "Flash"
  "Fade"
]

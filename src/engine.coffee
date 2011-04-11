( ($) ->
  defaults =
    FPS: 33.3333
    age: 0
    ambientLight: 1
    backgroundColor: "#FFFFFF"
    cameraTransform: Matrix.IDENTITY
    excludedModules: []
    includedModules: []
    paused: false

  ###*
  The Engine controls the game world and manages game state. Once you 
  set it up and let it run it pretty much takes care of itself.

  You can use the engine to add or remove objects from the game world.

  There are several modules that can include to add additional capabilities 
  to the engine.

  The engine fires events that you  may bind listeners to. Event listeners 
  may be bound with <code>engine.bind(eventName, callback)</code>

  <code>beforeAdd(entityData)</code> Observer or modify the 
  entity data before it is added to the engine.

  <code>afterAdd(gameObject)</code> Observe or
  configure a <code>gameObject</code> that has been added to the engine.

  <code>draw(canvas)</code> Called after the engine draws on the canvas, you 
  wish to draw additional things to the canvas.

  <code>update</code> Called after the engine updates all the game objects.
  @name Engine
  @constructor
  @param I
  ###
  window.Engine = (I) ->
    I ||= {}

    $.reverseMerge I, {
      objects: []
    }, defaults

    intervalId = null
    frameAdvance = false

    queuedObjects = []

    update = ->
      [I.objects, toRemove] = I.objects.partition (object) ->
        object.update()

      toRemove.invoke "trigger", "remove"

      I.objects = I.objects.concat(queuedObjects)
      queuedObjects = []

      self.trigger "update"

    draw = ->
      canvas.withTransform I.cameraTransform, (canvas) ->
        if I.backgroundColor
          canvas.fill(I.backgroundColor)

        I.objects.invoke("draw", canvas)

      self.trigger "draw", canvas

    step = ->
      if !I.paused || frameAdvance
        update()
        I.age += 1

      draw()

    canvas = I.canvas || $("<canvas />").powerCanvas()

    self = Core(I).extend
      ###*
      The add method creates and adds an object to the game world.

      Events triggered:
      <code>beforeAdd(entityData)</code>
      <code>afterAdd(gameObject)</code>

      @name add
      @methodOf Engine#
      @param entityData The data used to create the game object.
      ###
      add: (entityData) ->
        self.trigger "beforeAdd", entityData

        obj = GameObject.construct entityData

        self.trigger "afterAdd", obj

        if intervalId && !I.paused
          queuedObjects.push obj
        else
          I.objects.push obj

        return obj

      #TODO: This is a bad idea in case access is attempted during update
      objects: ->
        I.objects

      objectAt: (x, y) ->
        targetObject = null
        bounds =
          x: x
          y: y
          width: 1
          height: 1

        self.eachObject (object) ->
          targetObject = object if object.collides(bounds)

        return targetObject

      eachObject: (iterator) ->
        I.objects.each iterator

      ###*
      Start the game simulation.
      @methodOf Engine#
      @name start
      ###
      start: () ->
        unless intervalId
          intervalId = setInterval(() ->
            step()
          , 1000 / I.FPS)

      ###*
      Stop the simulation.
      @methodOf Engine#
      @name stop
      ###
      stop: ->
        clearInterval(intervalId)
        intervalId = null

      frameAdvance: ->
        I.paused = true
        frameAdvance = true
        step()
        frameAdvance = false

      play: ->
        I.paused = false

      ###*
      Pause the simulation
      @methodOf Engine#
      @name pause
      ###
      pause: ->
        I.paused = true

      paused: ->
        I.paused

      setFramerate: (newFPS) ->
        I.FPS = newFPS
        self.stop()
        self.start()

    self.attrAccessor "ambientLight"
    self.attrAccessor "backgroundColor"
    self.attrAccessor "cameraTransform"
    self.include Bindable

    defaultModules = ["Shadows", "HUD", "Developer", "SaveState", "Selector", "Collision"]
    modules = defaultModules.concat(I.includedModules)
    modules = modules.without(I.excludedModules)

    modules.each (moduleName) ->
      self.include Engine[moduleName]

    return self
)(jQuery)


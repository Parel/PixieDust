Engine.GameState = (I, self) ->
  Object.reverseMerge I,
    currentState: GameState()

  requestedState = null

  # The idea is that all the engine#beforeUpdate triggers happen
  # before the state beforeUpdate triggers, then the state update
  # then the state after update, then the engine after update
  # like a layered cake with states in the middle.
  self.bind "update", (elapsedTime) ->
    I.currentState.trigger "beforeUpdate", elapsedTime
    I.currentState.trigger "update", elapsedTime
    I.currentState.trigger "afterUpdate", elapsedTime

  self.bind "afterUpdate", ->
    # Handle state change
    if requestedState?
      I.currentState.trigger "exit", requestedState
      self.trigger 'stateExited', I.currentState

      previousState = I.currentState
      I.currentState = requestedState

      I.currentState.trigger "enter", previousState
      self.trigger 'stateEntered', I.currentState

      requestedState = null

  self.bind "draw", (canvas) ->
    I.currentState.trigger "beforeDraw", canvas
    I.currentState.trigger "draw", canvas
    I.currentState.trigger "overlay", canvas


  # Just pass through to the current state
  add: (className, entityData) ->
    # Allow optional add "Class", data form
    if entityData?
      entityData.class = className
    else
      entityData = className

    self.trigger "beforeAdd", entityData
    object = I.currentState.add(entityData)
    self.trigger "afterAdd", object

    return object

  camera: (n=0) ->
    self.cameras()[n]

  cameras: (newCameras) ->
    if newCameras?
      I.currentState.cameras(newCameras)

      return self
    else
      I.currentState.cameras()

  fadeIn: (options={}) ->
    self.cameras().invoke('fadeIn', options)

  fadeOut: (options={}) ->
    self.cameras().invoke('fadeOut', options)

  flash: (options={}) ->
    self.camera(options.camera).flash(options)

  objects: ->
    I.currentState.objects()

  setState: (newState) ->
    requestedState = newState

  shake: (options={}) ->
    self.camera(options.camera).shake(options)

  saveState: ->
    I.currentState.saveState()

  loadState: (newState) ->
    I.currentState.loadState(newState)

  reload: ->
    I.currentState.reload()

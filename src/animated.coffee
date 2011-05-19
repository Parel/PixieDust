Animated = (I, self) ->  
  I ||= {}

  $.reverseMerge I,
    animationName: null
    data:
      version: ""
      tileset: [
        id: 0
        src: ""
        title: ""
        circles: [{
          x: 0
          y: 0
          radius: 0
        }]
      ]
      animations: [{
         name: ""
         complete: ""
         interruptible: false
         speed: ""
         triggers: {
           "0": [""]
         }
         frames: [0]
      }]      
    spriteLookup: {}
    activeAnimation:
      name: ""
      complete: ""
      interruptible: false
      speed: ""
      triggers: {
        "0": [""]
      }
      frames: [0]
    currentFrameIndex: 0
    debugAnimation: true
    lastUpdate: new Date().getTime()
    useTimer: false
    transform: Matrix.IDENTITY

  loadByName = (name, callback) ->
    url = "#{BASE_URL}/data/#{name}.animation?#{new Date().getTime()}"

    $.getJSON url, (data) ->
      I.data = data

      callback? data

    return I.data

  I.data.tileset.each (spriteData, i) ->
    I.spriteLookup[i] = Sprite.fromURL(spriteData.src) 

  if I.data.animations.first().name != "" 
    I.activeAnimation = I.data.animations.first()
    I.currentFrameIndex = I.activeAnimation.frames.first()

    I.data.tileset.each (spriteData, i) ->
      I.spriteLookup[i] = Sprite.fromURL(spriteData.src) 
  else if I.animationName
    loadByName I.animationName, ->
      I.activeAnimation = I.data.animations.first()
      I.currentFrameIndex = I.activeAnimation.frames.first()

      I.data.tileset.each (spriteData, i) ->
        I.spriteLookup[i] = Sprite.fromURL(spriteData.src)  
  else
    throw "No animation data provided. Use animationName to specify an animation to load from the project or pass in raw JSON to the data key."

  advanceFrame = ->
    frames = I.activeAnimation.frames

    if I.currentFrameIndex == frames.last() 
      self.trigger("Complete") 

      nextState = I.activeAnimation.complete

      if nextState
        I.activeAnimation = find(nextState) || I.activeAnimation
        sprite = I.spriteLookup[I.activeAnimation.frames.first()]

        I.width = sprite.width
        I.height = sprite.height

    I.currentFrameIndex = I.activeAnimation.frames[(frames.indexOf(I.currentFrameIndex) + 1) % frames.length]

  find = (name) ->
    result = null
    nameLower = name.toLowerCase()

    I.data.animations.each (animation) ->
      result = animation if animation.name.toLowerCase() == nameLower

    return result  

  draw: (canvas) ->
    canvas.withTransform self.transform(), ->
      I.spriteLookup[I.currentFrameIndex].draw(canvas, I.x, I.y)

  transition: (newState) ->
    return if newState == I.activeAnimation.name
    unless I.activeAnimation.interruptible
      warn "Cannot transition to '#{newState}' because '#{I.activeAnimation.name}' is locked" if I.debugAnimation
      return

    nextState = find(newState)

    if nextState    
      I.activeAnimation = nextState
      firstFrame = I.activeAnimation.frames.first()
      firstSprite = I.spriteLookup[firstFrame]

      I.currentFrameIndex = firstFrame
      I.width = firstSprite.width
      I.height = firstSprite.height 
    else
      warn "Could not find animation state '#{newState}'. The current transition will be ignored" if I.debugAnimation

  transform: -> I.transform

  before:  
    update: ->       
      if I.useTimer
        time = new Date().getTime()

        if updateFrame = (time - I.lastUpdate) >= I.activeAnimation.speed
          I.lastUpdate = time
          if I.activeAnimation.triggers?[I.currentFrameIndex]
            I.activeAnimation.triggers[I.currentFrameIndex].each (event) ->
              self.trigger(event)

          advanceFrame()
      else
        if I.activeAnimation.triggers?[I.currentFrameIndex]
          I.activeAnimation.triggers[I.currentFrameIndex].each (event) ->
            self.trigger(event)

        advanceFrame()
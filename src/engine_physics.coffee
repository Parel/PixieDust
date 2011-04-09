Engine.Box2D = (I, self) ->
  $.reverseMerge I,
    scale: 0.1
    gravity: Point(0, 98)
    PHYSICS_DEBUG_DRAW: false

  world = new Box2D.Dynamics.b2World(new Box2D.Common.Math.b2Vec2(I.gravity.x, I.gravity.y), true)

  pendingCollisions = []
  pendingDestructions = []

  world.SetContactListener
    BeginContact: (contact) ->
      a = contact.GetFixtureA().GetBody().GetUserData()
      b = contact.GetFixtureB().GetBody().GetUserData()

      pendingCollisions.push([a, b])

    EndContact: (contact) ->
    PreSolve: (contact, oldManifold) ->
    PostSolve: (contact, impulse) ->

  fireCollisionEvents = () ->
    pendingCollisions.each (event) ->
      [a, b] = event

      a.trigger "collision", b
      b.trigger "collision", a

    pendingCollisions = []

  destroyPhysicsBodies = () ->
    pendingDestructions.each (body) ->
      world.DestroyBody(body)

    pendingDestructions = []

  self.bind "update", ->
    world.Step(1 / I.FPS, 10, 10)
    world.ClearForces()

    fireCollisionEvents()
    destroyPhysicsBodies()

  self.bind "draw", (canvas) ->
    if I.PHYSICS_DEBUG_DRAW
      unless debugDraw
        debugDraw = new b2DebugDraw()
        debugDraw.SetSprite(canvas.context())
        debugDraw.SetDrawScale(10)
        debugDraw.SetFillAlpha(0.3)
        debugDraw.SetLineThickness(1.0)
        debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit)
        world.SetDebugDraw(debugDraw)

      world.DrawDebugData()

  self.bind "beforeAdd", (entityData) ->
    entityData.world = world

  self.bind "afterAdd", (object) ->
    object.bind "destroy", ->
      pendingDestructions.push object.body()

  return {}


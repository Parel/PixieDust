module "Engine"

test "Flash", ->
  engine = Engine 
    backgroundColor: 'black'
    includedModules: ["Flash"]

  ok engine.I.flashColor.equal(Color(0, 0, 0, 0)) 
  equal engine.I.flashDuration, 12
  equal engine.I.flashCooldown, 0
  equal engine.I.flashTargetAlpha, 0

  engine.flash()  

  ok engine.I.flashColor.equal(Color('white')) 
  equal engine.I.flashDuration, 12
  equal engine.I.flashCooldown, 12
  equal engine.I.flashTargetAlpha, 0

  engine.update()

  ok engine.I.flashColor.a < 1
  equal engine.I.flashDuration, 12
  equal engine.I.flashCooldown, 11
  equal engine.I.flashTargetAlpha, 0  

module()
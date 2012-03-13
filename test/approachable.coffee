module "Approachable"

test "objects count down each of their cooldowns", ->
  obj = GameObject
    cooldowns:
      bullet:
        target: 0
        approachBy: 1
        value: 100

  obj.include(Approachable)

  5.times ->
    obj.update()

  equals obj.I.cooldowns.bullet.value, 95, "bullet cooldown should decrease by 5"

test "should handle negative value", ->
  obj = GameObject
    cooldowns:
      bullet:
        target: 0
        approachBy: 1
        value: -100

  obj.include(Approachable)

  11.times ->
    obj.update()

  equals obj.I.cooldowns.bullet.value, -89, "bullet cooldown should increase by 5"

test "#addCooldown", ->
  obj = GameObject()

  obj.include(Approachable)

  obj.addCooldown 'health'

  3.times ->
    obj.update()

  equals obj.I.cooldowns.health.value, 97, "health cooldown should exist and equal 97"  

module()
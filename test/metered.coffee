module 'Metered'

test "should exist", ->
  obj = GameObject()
  
  obj.include Metered
  
  ok obj.meter
  
test "should respect 0 being set as the meter attribute", ->
  obj = GameObject
    health: 0
    healthMax: 110
    
  obj.meter 'health'
  
  equals obj.I.health, 0
  
test "should set max<Attribute> if it isn't present in the including object", ->
  obj = GameObject
    health: 150
  
  obj.include Metered

  obj.meter 'health'
  
  equals obj.I.healthMax, 150

test "should set both <attribute> and max<attribute> if they aren't present in the including object", ->
  obj = GameObject()
  
  obj.include Metered
  
  obj.meter 'turbo'
    
  equals obj.I.turbo, 100
  equals obj.I.turboMax, 100
  
module()
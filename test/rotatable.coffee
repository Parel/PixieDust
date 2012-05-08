module("Rotatable")

test "objects update their rotation", ->
  obj = GameObject
    rotationalVelocity: Math.PI / 4
    rotation: Math.PI / 6


  equals obj.I.rotation, Math.PI / 6, "Respects default rotation value"

  2.times ->
    obj.update()

  equals obj.I.rotation, Math.PI / 2 + Math.PI / 6

  4.times ->
    obj.update()

  equals obj.I.rotation, (3 / 2) * Math.PI + Math.PI / 6

module()
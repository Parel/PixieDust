asyncTest "Animation should default to first frame", ->
  animation = Animation.fromPixieId 45
  
  milliseconds = 300
  
  setTimeout ->
    equals animation.currentSprite(), 0

    start()
  , milliseconds
 
asyncTest "Animation should increment frame on update", ->
  animation = Animation.fromPixieId 45
  
  milliseconds = 300
  
  setTimeout ->
    animation.update()
    
    equals animation.currentSprite(), 1

    start()
  , milliseconds

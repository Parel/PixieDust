module "Camera"



test "create", ->
  ok Camera()

test "overlay", 1, ->
  object = GameObject()

  camera = Camera()

  camera.trigger 'overlay', 
# Clear out the module
module()

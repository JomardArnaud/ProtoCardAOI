extends CanvasLayer

var ClassHibox2D = preload("res://Utility/CustomNode/Hitbox2D.gd")
#put the mode in same order the the enum
enum mouseMode {
	BASE,
	ON_TARGET,
	nb_mode
}
@onready var currentMode := mouseMode.BASE : set = setMode
#use to keep track with overlaping target  
@onready var nodeOverlaping : Array[int]
@export var tModeMouse : Array[Texture2D]
@onready var spriteMouse := %SpriteMouse

@export var baseWindowSize := Vector2.ZERO
@export var baseMouseSize := Vector2.ZERO

#part algo search for the closest targetable object of the cursor
@export var distanceSelect := 50

func _input(event: InputEvent):
	if (event is InputEventMouseButton):
		findCLosest()
	pass

func findCLosest() -> void:
	var mousePos : Vector2 = spriteMouse.get_global_mouse_position()
	for target in get_tree().get_nodes_in_group("targetable"):
		if target is Hitbox2D:
			var targetPos = target.get_global_transform_with_canvas().origin
			if (mousePos.distance_to(targetPos) < distanceSelect):
				target.visible = false
	pass
func _ready() -> void:
	spriteMouse.hide()
	updateCursorImage()

func _process(_delta: float) -> void:
	spriteMouse.global_position = spriteMouse.get_global_mouse_position()

#need to change this function to work with curosr ?
func setMode(nMode: mouseMode) -> void:
	if (nMode == mouseMode.BASE):
		currentMode = nMode
		updateCursorImage()
	#elif :
		#print(alternateModeWeight)
		#alternateModeWeight += 1

func updateCursorImage() -> void:
	var imageMouse = tModeMouse[currentMode].get_image()
	
	imageMouse.resize(baseMouseSize.x, baseMouseSize.y, Image.INTERPOLATE_NEAREST)
	Input.set_custom_mouse_cursor(imageMouse)

##from github
#extends CanvasLayer
#
#export(Texture) var empty_cursor = null
#export(Texture) var default_cursor = null
#export(Texture) var red_cursor = null
#
#export(Vector2) var base_window_size = Vector2.ZERO
#export(Vector2) var base_cursor_size = Vector2.ZERO
#
#func _ready():
	#$Sprite.hide()
	#update_cursor()
	#get_tree().connect("screen_resized", self, "update_cursor")
#
#func _process(delta):
	#$Sprite.global_position = $Sprite.get_global_mouse_position()
#
#func update_cursor():
	#var current_window_size = OS.window_size
	#var scale_multiple = min(floor(current_window_size.x / base_window_size.x), floor(current_window_size.y / base_window_size.y))
	#
	#var texture = ImageTexture.new()
	#var image = default_cursor.get_data()
	#image.resize(base_cursor_size.x * (scale_multiple + 1), base_cursor_size.y * (scale_multiple + 1), Image.INTERPOLATE_NEAREST)
	#texture.create_from_image(image)
	#
	#Input.set_custom_mouse_cursor(texture, Input.CURSOR_ARROW)

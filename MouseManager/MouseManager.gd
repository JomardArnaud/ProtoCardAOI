extends CanvasLayer

#put the mode in same order the the enum
enum mouseMode {
	BASE,
	ON_TARGET,
	nb_mode
}
@export var tModeMouse : Array[Texture2D]


@export var baseWindowSize := Vector2.ZERO
@export var baseMouseSize := Vector2.ZERO

@onready var spriteMouse := %SpriteMouse

@onready var currentMode := mouseMode.BASE : set = setMode

func _ready() -> void:
	spriteMouse.hide()
	updateCursorImage()
	pass

func _process(_delta: float) -> void:
	spriteMouse.global_position = spriteMouse.get_global_mouse_position()

func setMode(nMode: mouseMode) -> void:
	if (currentMode != nMode):
		currentMode = nMode
		
	pass

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

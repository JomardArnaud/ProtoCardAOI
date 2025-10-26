class_name InputManager
extends Node

static var instance: InputManager = null

static func get_instance() -> InputManager:
	if instance == null:
		push_error("None InputManager instanciate in the scene.")
	return instance

func _ready() -> void:
	# Si une instance existe déjà, on prévient
	if instance != null:
		push_error("Another instance of InputManager already exist.")
	instance = self
	
func _exit_tree() -> void:
	# On nettoie l'instance si le node disparaît
	if instance == self:
		instance = null

func getHotkeyStr(strInput: String) -> String:
	if InputMap.has_action(strInput):
		var debug = InputMap.action_get_events(strInput)
		if debug != null:
			return debug[0].as_text().split(" ")[0]
	return ""

func getDirAttack(player: PlayerController) -> Vector2:
	return getDirFromMouse(player).normalized()
 
func getDirDash(player: PlayerController) -> Vector2:
	return getDirFromMouse(player).normalized()

func getDirFromMouse(entity: Node) -> Vector2:
	var destDir : Vector2
	destDir = entity.get_global_mouse_position() - entity.global_position
	if destDir.length_squared() > 0.0001: 
		destDir = destDir.normalized()
	else :
		destDir = Vector2.ZERO
	return destDir

func isShooting() -> bool:
	var shooting : bool = false
	shooting = Input.is_action_pressed("Shoot")
	return shooting

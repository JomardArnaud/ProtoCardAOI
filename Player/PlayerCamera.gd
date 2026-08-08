extends Camera2D

@export var speedCamera := 1.0 
@export var focusEntity: Node2D

@onready var focusOnEntityDoubleTap = 0

const smooth_lean := 10.0
const scale_lean  := 0.35

func _ready() -> void:
	position_smoothing_enabled = true
	position_smoothing_speed = 10.0
	if focusEntity:
		teleport_to_target()

func setFocusEntity(new_focus: Node2D) -> void:
	focusEntity = new_focus
	if is_node_ready() && focusEntity:
		teleport_to_target()

func teleport_to_target() -> void:
	if !focusEntity || !is_instance_valid(focusEntity):
		return
		
	position_smoothing_enabled = false
	global_position = focusEntity.global_position
	offset = Vector2.ZERO
	reset_smoothing()
	
	get_tree().process_frame.connect(
		func(): position_smoothing_enabled = true,
		CONNECT_ONE_SHOT
	)
	
func _process(delta: float) -> void:
	if !focusEntity || !is_instance_valid(focusEntity):
		return

	position = focusEntity.position

	var mouse_position := get_global_mouse_position()
	var direction_to_mouse := (mouse_position - position).normalized()
	var distance_to_mouse := mouse_position.distance_to(position)
	var lean := direction_to_mouse * distance_to_mouse * scale_lean

	offset = lerp(offset, lean, delta * smooth_lean)

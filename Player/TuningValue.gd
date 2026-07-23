class_name TurnerPanel
extends PanelContainer

const FeedBackScene = preload("res://Utility/CustomNode/Feedback.tscn")

@export var toggleKey : Key = KEY_TAB
@export var player : PlayerController

@onready var speedLine = $MarginContainer/VBoxContainer/LineEdit
@onready var AccelerationLine = $MarginContainer/VBoxContainer/LineEdit2
@onready var DecelerationLine = $MarginContainer/VBoxContainer/LineEdit6
@onready var InertiaLine = $MarginContainer/VBoxContainer/LineEdit5
@onready var UTurnAccelLine = $MarginContainer/VBoxContainer/LineEdit4
@onready var SteeringAccelLine = $MarginContainer/VBoxContainer/LineEdit3
@onready var playerMoveBox : MovementBody2D

func _ready() -> void:
	set_process_unhandled_input(true)
	hide()
	get_tree().paused = false
	if player != null && !player.is_node_ready():
		await player.ready
	if player != null && player.commanderNode != null:
			playerMoveBox = player.commanderNode.body
			
			#speedLine.text = str(playerMoveBox.speed)
			setupTuner()

func _input(event: InputEvent) -> void:
	if event is InputEventKey && event.pressed && not event.echo:
		if event.keycode == toggleKey:
			toggleTuner()

func toggleTuner() -> void:
	visible = !visible
	get_tree().paused = visible
	#if visible && player != null:
		#speedLine.text = str(playerMoveBox.speed)

func setupTuner() -> void:
	bindInput(speedLine, playerMoveBox.speed, func(nValueText): playerMoveBox.speed = nValueText)
	bindInput(AccelerationLine, playerMoveBox.acceleration, func(nValueText): playerMoveBox.acceleration = nValueText)
	bindInput(DecelerationLine, playerMoveBox.deceleration, func(nValueText): playerMoveBox.deceleration = nValueText)
	bindInput(InertiaLine, playerMoveBox.inertia, func(nValueText): playerMoveBox.inertia = nValueText)
	bindInput(UTurnAccelLine, playerMoveBox.uTurnAccel, func(nValueText): playerMoveBox.uTurnAccel = nValueText)
	bindInput(SteeringAccelLine, playerMoveBox.steeringAccel, func(nValueText): playerMoveBox.steeringAccel = nValueText)

func bindInput(inputLine: LineEdit, variableToSet : float, updateCallback:Callable) -> void:
	inputLine.text = str(variableToSet)
	inputLine.text_submitted.connect(func(nText: String) :
		if nText.is_valid_float():
			updateCallback.call(nText.to_float()))
	inputLine.focus_exited.connect(func() :
		if inputLine.text.is_valid_float():
			updateCallback.call(inputLine.text))

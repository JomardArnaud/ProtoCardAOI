class_name TunerPanel
extends PanelContainer


@export var toggleKey : Key = KEY_TAB
@export var player : PlayerController

@onready var SpeedLine = $MarginContainer/VBoxContainer/Speed
@onready var AccelerationLine = $MarginContainer/VBoxContainer/Acceleration
@onready var DecelerationLine = $MarginContainer/VBoxContainer/Deceleration
@onready var InertiaLine = $MarginContainer/VBoxContainer/Inertia
@onready var UTurnAccelLine = $MarginContainer/VBoxContainer/UTurnAccel
@onready var SteeringAccelLine = $MarginContainer/VBoxContainer/SteeringAccel
@onready var playerMoveBox : MovementBody2D

func _ready() -> void:
	set_process_unhandled_input(true)
	hide()
	get_tree().paused = false
	if player != null && !player.is_node_ready():
		await player.ready
	if player != null && player.commander != null:
			playerMoveBox = player.commander.body
			
			#SpeedLine.text = str(playerMoveBox.speed)
			setupTuner()

func _input(event: InputEvent) -> void:
	if event is InputEventKey && event.pressed && not event.echo:
		if event.keycode == toggleKey:
			toggleTuner()

func toggleTuner() -> void:
	visible = !visible
	get_tree().paused = visible
	#if visible && player != null:
		#SpeedLine.text = str(playerMoveBox.speed)

func setupTuner() -> void:
	bindInput(SpeedLine, playerMoveBox.speed, func(nValueText): playerMoveBox.speed = nValueText)
	bindInput(AccelerationLine, playerMoveBox.acceleration, func(nValueText): playerMoveBox.acceleration = nValueText)
	bindInput(DecelerationLine, playerMoveBox.deceleration, func(nValueText): playerMoveBox.deceleration = nValueText)
	bindInput(InertiaLine, playerMoveBox.inertia, func(nValueText): playerMoveBox.inertia = nValueText)
	bindInput(UTurnAccelLine, playerMoveBox.uTurnAccel, func(nValueText): playerMoveBox.uTurnAccel = nValueText)
	bindInput(SteeringAccelLine, playerMoveBox.steeringAccel, func(nValueText): playerMoveBox.steeringAccel = nValueText)

func bindInput(inputLine: LineEdit, variableToSet : float, updateCallback:Callable) -> void:
	inputLine.text = str(variableToSet)
	var bufferValue : Array = [variableToSet]
	var applyValue = func():
		if inputLine.text.is_valid_float():
			var tmpValue = inputLine.text.to_float()
			if tmpValue != bufferValue[0]:
				bufferValue[0] = tmpValue
				updateCallback.call(tmpValue)
				Feedback.spawnFeedback(player, String(inputLine.name + "has been update to " + inputLine.text))
			else:
				inputLine.text = str(bufferValue[0])
	inputLine.text_submitted.connect(func(_nText: String) : applyValue.call())
	inputLine.focus_exited.connect(func() : applyValue.call())

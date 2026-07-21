extends Control

@export var timeBeforeFading : float = 0.5
@export var durationFade : float = 1
@export var text : String : set = setText

@onready var textNode : RichTextLabel = $PanelContainer/MarginContainer/RichTextLabel

func _ready() -> void:
	updateUI()
	popUp()

func setText(nText: String) -> void:
	if is_node_ready():
		textNode.text = text 

func popUp() -> void:
	modulate.a = 1
	var tween = create_tween()
	tween.tween_interval(timeBeforeFading)
	tween.tween_property(self, "modulate:a", 0.0, durationFade)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	tween.tween_callback(queue_free)

func updateUI() -> void:
	textNode.text = "[center]%s[center]" % text

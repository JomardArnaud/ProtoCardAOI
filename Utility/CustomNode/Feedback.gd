class_name Feedback
extends CanvasLayer

const sceneFeedback = preload("res://Utility/CustomNode/Feedback.tscn")

@export var timeBeforeFading : float = 0.5
@export var durationFade : float = 1
@export var text : String : set = setText

@onready var textNode : RichTextLabel = $PanelContainer/MarginContainer/RichTextLabel
@onready var panelContainer : PanelContainer = $PanelContainer

static func spawnFeedback(owner: Node, nText : String) -> Feedback:
	var nFeedback = sceneFeedback.instantiate() as Feedback
	nFeedback.text = nText
	owner.add_child(nFeedback)
	return nFeedback

func _ready() -> void:
	updateUI()
	popUp()

func setText(nText: String) -> void:
	text = nText
	if is_node_ready():
		updateUI() 

func popUp() -> void:
	panelContainer.modulate.a = 1
	var tween = create_tween()
	tween.tween_interval(timeBeforeFading)
	tween.tween_property(panelContainer, "modulate:a", 0.0, durationFade)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	tween.tween_callback(queue_free)

func updateUI() -> void:
	textNode.text = "[center]%s[/center]" % text

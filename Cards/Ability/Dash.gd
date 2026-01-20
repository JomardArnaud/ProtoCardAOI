extends CardAbility

signal dash()

@onready var durationTimer : Timer

var power : float

func resolve() -> void:
	if durationTimer.time_left > 0:
		_on_duration_timeout()
	var dirDash : Vector2 = caster.getDirDash.call()
	caster.body.setDir(dirDash.normalized())
	caster.body.addSpeed(power)
	caster.body.lockDir(true)
	durationTimer.start()

func init() -> void:
	var descriptionParsed = description.split('/')
	power = float(descriptionParsed[0])
	durationTimer = Timer.new()
	durationTimer.one_shot = true
	durationTimer.wait_time = float(descriptionParsed[1])
	durationTimer.timeout.connect(_on_duration_timeout)
	add_child(durationTimer)
	
func _on_duration_timeout() -> void:
	caster.body.lockDir(false)
	caster.body.addSpeed(-power)
	caster.body.resetEnergy(Vector2(0.3, 0.3))

func setupParam(nParam: Dictionary) -> void:
	pass

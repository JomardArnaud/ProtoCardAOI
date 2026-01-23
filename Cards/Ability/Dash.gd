extends CardAbilityNode

signal dash()

var defaultParam = {
	"duration" : 0.2,
	"power" : 3000
}

@onready var durationTimer : Timer

func resolve() -> void:
	if durationTimer.time_left > 0:
		_on_duration_timeout()
	var dirDash : Vector2 = caster.getDirDash.call()
	caster.body.setDir(dirDash.normalized())
	caster.body.addSpeed(defaultParam.get("power"))
	caster.body.lockDir(true)
	durationTimer.start()
	
func _on_duration_timeout() -> void:
	caster.body.lockDir(false)
	caster.body.addSpeed(-defaultParam.get("power"))
	caster.body.resetEnergy(Vector2(0.3, 0.3))

func setupParam(nParam: Dictionary) -> void:
	defaultParam.merge(nParam, true)
	if not durationTimer:
		durationTimer = Timer.new()
		durationTimer.one_shot = true
		durationTimer.wait_time = float(defaultParam.get("duration"))
		durationTimer.timeout.connect(_on_duration_timeout)
		add_child(durationTimer)

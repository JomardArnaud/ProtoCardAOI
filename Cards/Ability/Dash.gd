extends CardAbility

signal dash()

@onready var durationTimer : Timer

var power : float

func resolve() -> void:
	# Si un dash est déjà en cours, on l'annule avant de lancer un nouveau
	if durationTimer.time_left > 0:
		_on_duration_timeout()
	## TODO if NPC use Dash need to remake this
	var dirDash : Vector2 = caster.getDirDash.call()
	caster.setDir(dirDash.normalized())
	caster.lockDir(true)
	caster.addSpeed(power)
	durationTimer.start()
	pass

func init() -> void:
	var descriptionParsed = description.split('/')
	power = float(descriptionParsed[0])
	durationTimer = Timer.new()
	durationTimer.one_shot = true
	durationTimer.wait_time = float(descriptionParsed[1])
	durationTimer.timeout.connect(_on_duration_timeout)
	add_child(durationTimer)
	
func _on_duration_timeout() -> void:
	caster.lockDir(false)
	caster.addSpeed(-power)
	caster.resetEnergy(Vector2(0.3, 0.3))

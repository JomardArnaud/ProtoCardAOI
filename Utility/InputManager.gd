extends Node

func getHotkeyStr(strInput: String) -> String:
	if InputMap.has_action(strInput):
		var events = InputMap.action_get_events(strInput)
		if events != null && !events.is_empty():
			return events[0].as_text().split(" ")[0]
	return ""

func getDirAttack(player: PlayerController) -> Vector2:
	return getDirFromMouse(player).normalized()
 
func getDirDash(player: PlayerController) -> Vector2:
	return getDirFromMouse(player).normalized()

func getDirFromMouse(entity: Node) -> Vector2:
	if !entity || !is_instance_valid(entity):
		return Vector2.ZERO
	var destDir : Vector2
	destDir = entity.get_global_mouse_position() - entity.global_position
	if destDir.length_squared() > 0.0001: 
		return destDir.normalized()
	return Vector2.ZERO

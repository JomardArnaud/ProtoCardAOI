class_name InputManager
extends Node

# Constantes pour les types de manettes
const GAMEPAD_TYPES = {
	"Xbox": {
		0: "A",
		1: "B",
		2: "X",
		3: "Y",
		4: "LB",
		5: "RB",
		6: "LT",
		7: "RT",
		8: "Back",
		9: "Start",
		10: "L3",
		11: "R3",
		12: "D-Pad Up",
		13: "D-Pad Down",
		14: "D-Pad Left",
		15: "D-Pad Right"
	},
	"PlayStation": {
		0: "X",
		1: "O",
		2: "□",
		3: "△",
		4: "L1",
		5: "R1",
		6: "L2",
		7: "R2",
		8: "Share",
		9: "Options",
		10: "L3",
		11: "R3",
		12: "D-Pad Up",
		13: "D-Pad Down",
		14: "D-Pad Left",
		15: "D-Pad Right"
	},
	"Generic": {
		0: "Button 1",
		1: "Button 2",
		2: "Button 3",
		3: "Button 4",
		4: "Button 5",
		5: "Button 6",
		6: "Button 7",
		7: "Button 8",
		8: "Button 9",
		9: "Button 10",
		10: "Button 11",
		11: "Button 12",
		12: "D-Pad Up",
		13: "D-Pad Down",
		14: "D-Pad Left",
		15: "D-Pad Right"
	}
}

# Variable pour stocker le type de manette actuellement utilisée
var gamepads : Array[int]
var gamepadsType : Dictionary
var gamepadActive : bool = false

func _init() -> void:
	# Check already connected gamepad
	gamepads = Input.get_connected_joypads()
	if gamepads.is_empty():
		print("No gamepad detected")
	else:
		gamepadActive = true
		for idGamepad in gamepads:
			setGamepadType(idGamepad)
	# Connexion des signaux
	Input.joy_connection_changed.connect(on_joy_connection_changed)

## TODO make a connect detect input for new controller plug or from state of no input since 5sec to a new input setting gamepadActive true 

func getHotkeyStr(strInput: String) -> String:
	if InputMap.has_action(strInput):
		var debug = InputMap.action_get_events(strInput)[1 - int(gamepadActive)]
		if gamepadActive : 
			return get_button_name(0, InputMap.action_get_events(strInput))
		else :
			return debug.as_text().split(" ")[0]
	return ""

# Détecte le type de manette en fonction du nom du contrôleur
func setGamepadType(idGamepad: int) -> void:
	var joypad_name = Input.get_joy_name(idGamepad).to_lower()
	if joypad_name.find("ps") >= 0 or joypad_name.find("dualshock") >= 0 or joypad_name.find("sony") >= 0:
		gamepadsType[idGamepad] = "PlayStation"
	else:
		gamepadsType[idGamepad] = "Xbox"

# Retourne le nom du bouton en fonction de son type et de son index
func get_button_name(idGamepad: int, idsKeyInput: Array[InputEvent]) -> String:
	if idsKeyInput.is_empty():
		return "Unknown"	
	var event = idsKeyInput[0]  # Récupérer le premier événement lié à l'action
	if event is InputEventJoypadButton:
		return GAMEPAD_TYPES.get(gamepadsType.get(idGamepad, "Default"), {}).get(event.button_index, "Unknown")
	elif event is InputEventJoypadMotion:
		return GAMEPAD_TYPES.get(gamepadsType.get(idGamepad, "Default"), {}).get(event.axis + 2, "Unknown")
	return "Unknown"  # Si ce n'est ni un bouton ni une gâchette

func on_joy_connection_changed(device: int, connected: bool) -> void:
	if (connected):
		setGamepadType(device)
	else :
		gamepadsType[device] = ""
	

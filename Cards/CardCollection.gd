class_name CardCollection

var collection : Array[CardInfo] = [] : get = getCollection

func _init() -> void:
	fillCollection()

func getCollection():
	return collection

func getCardById(idCard: int):
	if idCard > collection.size():
		idCard = 0
		printerr("idCard isn't in the scope")	
	return collection[idCard]
	
func fillCollection():
	print("Waiting collection to finishing collecting ...")
	var numberCards : int = 2
	collection.resize(numberCards)
	collection[0] = CardInfo.new("Ida's Wind", "2/1", "Spell - Attack", "Gain 1 CWind|Skillshot 2*X(CWind)")
	collection[1] = CardInfo.new("Wind rises", "5/-1", "Spell - Movement", "Dash 1200/0.2 | AfterDash TmpGain 250/1 MS")
	print("Collection has finished")

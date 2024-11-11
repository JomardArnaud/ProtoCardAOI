class_name CardCollection

var ClassCard = preload("res://Cards/Card.gd")
var ClassCardInfo = preload("res://Cards/CardInfo.gd")
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
	var testCard = CardInfo.new("Ida's Wind", "0", ClassCardInfo.CardType.SPELL, "Gain 1 CWind | Deal 3+X(CWind) | ReturnCopy 5 | Exhaust")
	collection.push_back(testCard)
	print("Collection has finished")

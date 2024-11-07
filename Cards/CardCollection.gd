class_name CardCollection

var collection : Array[CardInfo] = [] : get = getCollection

func _init():
	print("...")
	
func getCollection():
	return collection

func getCardById(idCard: int):
	if idCard > collection.size():
		idCard = 0
		printerr("idCard isn't in the scope")	
	return collection[idCard]
	
func fillCollection():
	print("Waiting collection to finishing collecting ...")
	collection.push_back(CardInfo.new("Ida's Wind", "0", "spell", "Gain 1 CWind | Deal 3+X(CWind) | ReturnCopy 5 | Exhaust"))
	print("Collection has finished")

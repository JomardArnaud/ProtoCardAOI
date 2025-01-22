class_name CardKeyword
	
var listLinkWord = ["If ", "When ", "Before", "After"]
var listKeyword = {
	"Gain": {
		
	},
	"SkillShot": {
		"resolve" = func (): print("test")
	},
	"": {
		
	}
}

##all link word
static func After(rest : String):
	pass
	
func parseKeyword(keyword: String) -> void:	
	for linkWord in listLinkWord:
		if keyword.find(linkWord) != -1:
			linkWord.call()
			return
	pass

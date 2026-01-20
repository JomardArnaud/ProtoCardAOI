class_name CardCollection
extends Node

const CardEnum = preload("res://Cards/CardEnum.gd")
const CardInfo = preload("res://Cards/CardInfo.gd")

var collection : Dictionary[int, CardInfo] = {
	##TODO counter Shot, each ability with 'Shot' is resolve gain 1 counter Shot
#CardInfo.new("Ida's Wind", 0, CardEnum.CardType.ATTACK, [skillShot(10, 300), posio(5)])
	0: CardInfo.new("Ida's Wind", 0, CardEnum.CardType.ATTACK, "SkillShot 10/300"), ##TODO 10X(nbUSed"Ida's Wind" or nbCounter"Shot")/300 
	1: CardInfo.new("Wind rises", 1, CardEnum.CardType.DASH, "Dash 3000/0.15 | Wind(1)"), ##TODO Counter 
	2: CardInfo.new("Blank Attack", 1, CardEnum.CardType.ATTACK, "Blank"),
	3: CardInfo.new("Blank Dash", 1, CardEnum.CardType.DASH, "Blank"),
	4: CardInfo.new("Blank Spell", 1, CardEnum.CardType.SPELL, "Blank"),
	##TODO implemente keyword and X() synthax, AutoCast X _ (Card with AutoCast can't be send to SlotHand,   
	5: CardInfo.new('IchiNoKata attack', 1, CardEnum.CardType.ATTACK, "FreeCost Dash | DashShot X(DashVelocity)"),
	6: CardInfo.new('Hanabi attack', 0, CardEnum.CardType.ATTACK, "AutoCast  |  "),
	7: CardInfo.new('Negation will', 0, CardEnum.CardType.SPELL, "Counter") # (Counter All) # Counter = Cancel X all effect from the last X type of card(can be all type)resolved within a time limit of 0.5 sec
	
} : get = getCollection

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
	print("Collection has finished")

##func descritpionParsing() -> void:
	#var cardParsedAbilities = cardInfo.description.split(" | ")
	#for abilityKeyword : String in cardParsedAbilities:
		#var parsedAbility : PackedStringArray = abilityKeyword.split(" ", true, 1)
		#var keyword : String = parsedAbility[0]
		#var path = String("res://Cards/Ability/" + keyword + ".gd")
		#if ResourceLoader.exists(path):
			#var ability : CardAbility
			#if parsedAbility.size() > 1:
				#ability = load(path).new(commander, parsedAbility[1])
			#else : 
				#ability = load(path).new(commander, "")
			#ability.init()
			#cardAbilities[keyword] = ability
			#add_child(ability)
		#else:
			#push_error(keyword, " Keyword's ability not find")

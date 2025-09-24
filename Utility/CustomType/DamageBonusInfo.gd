extends Resource

#when the card is casted add this value to all direct attack number
@export var flatDirectDmgBonus : float
#when the card is casted add this value to all indirect attack number
@export var flatIndirectDmgBonus : float
#Come last in the calculation of direct damage output, mutl all direct attack number by this coef 
@export var coefDirectDmgBonus : float
#Come last in the calculation of indirect damage output, mutl all indirect attack number by this coef 
@export var coefIndirectDmgBonus : float

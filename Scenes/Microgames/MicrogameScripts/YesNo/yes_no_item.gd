extends Sprite2D

const CAKE_FRAME = 6
const TEMPURA_FRAME = 7
const KABAB_FRAME = 8

func change_appearance(item_num) -> void:
	if item_num == 0:
		frame = CAKE_FRAME
	elif item_num == 1:
		frame = TEMPURA_FRAME
	elif item_num == 2:
		frame = KABAB_FRAME
	else:
		return

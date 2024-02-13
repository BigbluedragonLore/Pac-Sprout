class_name MazeTileMap
extends TileMap


var empty_cells = []

func _ready():
	var cells = get_used_cells(1)
	
	for cell in cells:
		var data = get_cell_tile_data(1, cell)
		if data.get_custom_data("isEmpty"):
			empty_cells.push_front(cell)

func get_random_empty_cell_position():
	return to_global((map_to_local(empty_cells.pick_random())))

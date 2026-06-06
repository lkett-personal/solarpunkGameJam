class_name House extends Machine

func init():
	var house = Machine.new()
	house.height = 2
	house.width = 1
	house.depth = 1
	house.cost = 250
	house.atlas_coords = Vector2i(2, 2)
	house.cell_type_requirement = "rock"
	house.has_scene = false
	house.effect_radius = 0
	house.generates_energy = false
	house.has_power = false
	house.restores_tiles = false
	house.requires_power = false
	return house

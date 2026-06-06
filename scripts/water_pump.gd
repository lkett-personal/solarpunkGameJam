class_name WaterPump extends Machine

func init() -> Machine:
	var water_pump = Machine.new()
	water_pump.height = 1
	water_pump.width = 1
	water_pump.depth = 1
	water_pump.cost = 100
	water_pump.atlas_coords = Vector2i(2, 0)
	water_pump.cell_type_requirement = "muck"
	water_pump.has_scene = false
	water_pump.effect_radius = 4
	water_pump.generates_energy = false
	water_pump.has_power = false
	water_pump.restores_tiles = false
	water_pump.restores_water = true
	water_pump.requires_power = true
	return water_pump

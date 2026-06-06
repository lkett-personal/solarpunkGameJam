class_name Turbine extends Machine

func init() -> Machine:
	var turbine = Machine.new()
	turbine.height = 2
	turbine.width = 1
	turbine.depth = 1
	turbine.cost = 100
	turbine.atlas_coords = Vector2i(3, 0)
	turbine.cell_type_requirement = "rock"
	turbine.has_scene = true
	turbine.effect_radius = 4
	turbine.generates_energy = true
	turbine.has_power = false
	turbine.restores_tiles = false
	turbine.requires_power = false
	return turbine

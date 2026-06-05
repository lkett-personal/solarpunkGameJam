class_name Machine extends Node2D

@export var tile_pos: Vector2i
@export var atlas_coords: Vector2i
@export var cost: int
@export var height: int
@export var width: int
@export var depth: int
@export var cell_type_requirement: String
@export var has_scene: bool
@export var generates_energy: bool
@export var generate_energy_amount: int
@export var effect_radius: int
@export var has_power: bool
@export var restores_tiles: bool
@export var requires_power: bool

func get_turbine() -> Machine:
	var turbine = Machine.new()
	turbine.height = 2
	turbine.width = 1
	turbine.depth = 1
	turbine.cost = 100
	turbine.atlas_coords = Vector2i(3, 0)
	turbine.cell_type_requirement = "rock"
	turbine.has_scene = true
	turbine.effect_radius = 8
	turbine.generates_energy = true
	turbine.has_power = false
	turbine.restores_tiles = false
	turbine.requires_power = false
	return turbine
	
func get_toxin_scrubber() -> Machine:
	var toxin_scrubber = Machine.new()
	toxin_scrubber.height = 1
	toxin_scrubber.width = 1
	toxin_scrubber.depth = 1
	toxin_scrubber.cost = 250
	toxin_scrubber.atlas_coords = Vector2i(2, 1)
	toxin_scrubber.cell_type_requirement = "soil"
	toxin_scrubber.has_scene = false
	toxin_scrubber.effect_radius = 2
	toxin_scrubber.generates_energy = false
	toxin_scrubber.has_power = false
	toxin_scrubber.restores_tiles = true
	toxin_scrubber.requires_power = true
	return toxin_scrubber

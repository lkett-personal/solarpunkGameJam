extends Node2D

@onready var building_outline = $TileOutline
@onready var props = $Props
@onready var ground = $Ground
@onready var old_buildings = $Buildings
@onready var money_label: Label = get_tree().get_first_node_in_group("money_counter")

var money: int = 1000
var current_building: Machine = null
var buildings: Dictionary[Vector2i, Machine] = {}
var restored_variants: Dictionary[Vector2i, Vector2i] = {
	Vector2i(0, 0): Vector2i(0, 1),
	Vector2i(1, 0): Vector2i(1, 1)
}
var powered_cells: Dictionary[Vector2i, int] = {}

func _physics_process(_delta: float) -> void:
	building_outline.global_position = props.map_to_local(props.local_to_map(get_global_mouse_position()))
	
	if Input.is_action_just_pressed("ui_1"):
		current_building = Turbine.new().init()
	elif Input.is_action_just_pressed("ui_2"):
		current_building = ToxinScrubber.new().init()
	elif Input.is_action_just_pressed("ui_3"):
		current_building = WaterPump.new().init()
	elif Input.is_action_just_pressed("ui_4"):
		current_building = House.new().init()
		
	
	if Input.is_action_just_pressed("place_building") and current_building != null and current_building.cost <= money:
		current_building.tile_pos = props.local_to_map(building_outline.global_position)
		if buildings.has(current_building.tile_pos) == false and old_buildings.get_cell_tile_data(current_building.tile_pos) == null:
			var custom_tile_data = ground.get_cell_tile_data(current_building.tile_pos)
			
			if custom_tile_data == null:
				return
				
			var cell_type = custom_tile_data.get_custom_data("cell_type")
			
			var valid_tile = (current_building.cell_type_requirement == "" or current_building.cell_type_requirement == null or cell_type == current_building.cell_type_requirement)
			
			var has_power = (not current_building.requires_power or powered_cells.has(current_building.tile_pos))
			
			if not valid_tile or not has_power:
				return
	
			if !buildings.has(current_building.tile_pos):
				buildings[current_building.tile_pos] = current_building
				
			if current_building.has_scene:
				props.set_cell(current_building.tile_pos - Vector2i(0, current_building.height * 3), 1, Vector2i.ZERO, 1)

			props.set_cell(current_building.tile_pos, 0, current_building.atlas_coords)

			money -= current_building.cost
			money_label.text = str(money)
			
			var placed_building = current_building
			
			if placed_building.generates_energy:
				placed_building.affect_buildings(placed_building.tile_pos, placed_building.effect_radius, ground, powered_cells)
			elif placed_building.restores_tiles:
				placed_building.affect_tiles(placed_building.tile_pos, placed_building.effect_radius, ground, restored_variants)
			elif placed_building.restores_water:
				placed_building.affect_water(placed_building.tile_pos, placed_building.effect_radius, ground, restored_variants)
	
	if Input.is_action_just_pressed("break_building"):
		var tile_pos = old_buildings.local_to_map(building_outline.global_position)
		
		if old_buildings.get_cell_tile_data(tile_pos) != null:
			old_buildings.erase_cell(tile_pos)
			money += 50
			money_label.text = str(money)
			
		if props.get_cell_tile_data(tile_pos) != null:
			props.erase_cell(tile_pos)
			props.erase_cell(tile_pos - Vector2i(0, Turbine.new().init().height * 3)) # erase the scene tile if there
			buildings.erase(tile_pos)
			money += 50
			money_label.text = str(money)

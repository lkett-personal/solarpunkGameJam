extends Node2D

@onready var building_outline = $TileOutline
@onready var props = $Props
@onready var ground = $Ground
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
		current_building = Machine.new().get_turbine()
	elif Input.is_action_just_pressed("ui_2"):
		current_building = Machine.new().get_toxin_scrubber()
		
	
	if Input.is_action_just_pressed("place_building") and current_building != null and current_building.cost <= money:
		current_building.tile_pos = props.local_to_map(building_outline.global_position)
		if buildings.has(current_building.tile_pos) == false:
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
				affect_buildings(placed_building.tile_pos, placed_building.effect_radius)
			elif placed_building.restores_tiles:
				affect_tiles(placed_building.tile_pos, placed_building.effect_radius)

func affect_buildings(center_pos: Vector2i, radius: int) -> void:
	var check_range = radius + 2 
	
	var center_pixel: Vector2 = ground.map_to_local(center_pos)
	var single_tile_width: float = ground.map_to_local(center_pos + Vector2i(1, 0)).distance_to(center_pixel)
	
	var max_pixel_distance: float = (radius * single_tile_width) + 2.0

	for offset_x in range(-check_range, check_range + 1):
		for offset_y in range(-check_range, check_range + 1):
			var tile_pos = center_pos + Vector2i(offset_x, offset_y)
			var target_pixel: Vector2 = ground.map_to_local(tile_pos)
			
			if center_pixel.distance_to(target_pixel) <= max_pixel_distance:
				powered_cells[tile_pos] = powered_cells.get(tile_pos, 0) + 1

func affect_tiles(center_pos: Vector2i, radius: int) -> void:
	var check_range = radius + 2
	var center_pixel: Vector2 = ground.map_to_local(center_pos)
	var single_tile_width: float = ground.map_to_local(center_pos + Vector2i(1, 0)).distance_to(center_pixel)
	var max_pixel_distance: float = (radius * single_tile_width) + 2.0

	for offset_x in range(-check_range, check_range + 1):
		for offset_y in range(-check_range, check_range + 1):
			var tile_pos = center_pos + Vector2i(offset_x, offset_y)
			var target_pixel: Vector2 = ground.map_to_local(tile_pos)
			
			if center_pixel.distance_to(target_pixel) <= max_pixel_distance:
				var atlas = ground.get_cell_atlas_coords(tile_pos)
				if restored_variants.has(atlas):
					ground.set_cell(tile_pos, 0, restored_variants[atlas])

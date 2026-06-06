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
@export var restores_water: bool
@export var requires_power: bool

func affect_buildings(center_pos: Vector2i, radius: int, ground: TileMapLayer, powered_cells: Dictionary) -> void:
	var check_range = radius + 2 
	
	var center_pixel: Vector2 = ground.map_to_local(center_pos)
	var single_tile_width: float = ground.map_to_local(center_pos + Vector2i(1, 0)).distance_to(center_pixel)
	
	var max_pixel_distance: float = (radius * single_tile_width) + 2.0

	for offset_x in range(-check_range, check_range + 1):
		for offset_y in range(-check_range, check_range + 1):
			var tile_position = center_pos + Vector2i(offset_x, offset_y)
			var target_pixel: Vector2 = ground.map_to_local(tile_position)
			
			if center_pixel.distance_to(target_pixel) <= max_pixel_distance:
				powered_cells[tile_position] = powered_cells.get(tile_position, 0) + 1
				
func affect_tiles(center_pos: Vector2i, radius: int, ground: TileMapLayer, restored_variants: Dictionary) -> void:
	var check_range = radius + 2
	var center_pixel: Vector2 = ground.map_to_local(center_pos)
	var single_tile_width: float = ground.map_to_local(center_pos + Vector2i(1, 0)).distance_to(center_pixel)
	var max_pixel_distance: float = (radius * single_tile_width) + 2.0

	for offset_x in range(-check_range, check_range + 1):
		for offset_y in range(-check_range, check_range + 1):
			var tile_position = center_pos + Vector2i(offset_x, offset_y)
			var target_pixel: Vector2 = ground.map_to_local(tile_position)
			
			if center_pixel.distance_to(target_pixel) <= max_pixel_distance:
				var atlas = ground.get_cell_atlas_coords(tile_position)
				if restored_variants.has(atlas) and atlas == Vector2i(0, 0):
					ground.set_cell(tile_position, 0, restored_variants[atlas])
					
func affect_water(center_pos: Vector2i, radius: int, ground: TileMapLayer, restored_variants: Dictionary) -> void:
	var check_range = radius + 2
	var center_pixel: Vector2 = ground.map_to_local(center_pos)
	var single_tile_width: float = ground.map_to_local(center_pos + Vector2i(1, 0)).distance_to(center_pixel)
	var max_pixel_distance: float = (radius * single_tile_width) + 2.0

	for offset_x in range(-check_range, check_range + 1):
		for offset_y in range(-check_range, check_range + 1):
			var tile_position = center_pos + Vector2i(offset_x, offset_y)
			var target_pixel: Vector2 = ground.map_to_local(tile_position)
			
			if center_pixel.distance_to(target_pixel) <= max_pixel_distance:
				var atlas = ground.get_cell_atlas_coords(tile_position)
				if restored_variants.has(atlas) and atlas == Vector2i(1, 0):
					ground.set_cell(tile_position, 0, restored_variants[atlas])

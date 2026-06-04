extends Node2D

@onready var building_outline = $TileOutline
@onready var tilemap = $Props

@export var buildings: Array[PackedScene] = []

enum ActiveBuilding {
	SOLAR_PANEL,
	TURBINE,
	SPRINKLER,
	IRRIGATOR
}

func _physics_process(_delta: float) -> void:
	building_outline.global_position = tilemap.map_to_local(tilemap.local_to_map(get_global_mouse_position()))

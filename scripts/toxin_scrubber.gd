class_name ToxinScrubber extends Machine

func init() -> Machine:
	var toxin_scrubber = Machine.new()
	toxin_scrubber.height = 1
	toxin_scrubber.width = 1
	toxin_scrubber.depth = 1
	toxin_scrubber.cost = 65
	toxin_scrubber.atlas_coords = Vector2i(2, 1)
	toxin_scrubber.cell_type_requirement = "soil"
	toxin_scrubber.has_scene = false
	toxin_scrubber.effect_radius = 4
	toxin_scrubber.generates_energy = false
	toxin_scrubber.has_power = false
	toxin_scrubber.restores_tiles = true
	toxin_scrubber.restores_water = false
	toxin_scrubber.requires_power = true
	return toxin_scrubber

extends Resource
class_name LevelList

@export_category("Cutscenes")
## Scene played before the first level
@export var intro_cutscene: PackedScene
## Scene played after the last level
@export var outro_cutscene: PackedScene

@export_category("Levels")
## Ordered list of gameplay level scenes
@export var levels: Array[PackedScene] = []

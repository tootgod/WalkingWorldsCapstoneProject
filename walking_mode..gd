extends Node3D

@export var walk_speed := 2.0
@export var planet_radius := 5.0

@onready var planet: Node3D = $Planet


func _ready():
	$CanvasLayer/BackButton.pressed.connect(_on_back_pressed)


func _process(delta):
	planet.rotate_x(walk_speed / planet_radius * delta)


func _on_back_pressed():
	get_tree().change_scene_to_file("res://main.tscn")  # 실제 메인 씬 경로로 수정

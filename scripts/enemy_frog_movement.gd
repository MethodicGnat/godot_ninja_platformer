extends Area2D


@onready var sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

var debounce := false
static var score := 0

func _physics_process(_delta: float) -> void:
	var time = Time.get_datetime_dict_from_system()
	
	if time.second % 5 == 0 and time.second != 0 and !debounce:
		animation_player.play("RESET")
		animation_player.play("jump")
		sprite.play("jump")
		debounce = true
		await animation_player.animation_finished
		sprite.play("idle")
		debounce = false


func _on_body_entered(_body: Node2D) -> void:
	get_tree().call_deferred("reload_current_scene")# Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	if area.visible:
		self.queue_free() # Replace with function body.

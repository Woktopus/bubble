extends Control

func update_progress_bar(new_value:int)->void:
	$ProgressBar.value=new_value
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends Timer
@export var label : RichTextLabel
@export var txt : String



func _on_timeout() -> void:
	label.text = txt

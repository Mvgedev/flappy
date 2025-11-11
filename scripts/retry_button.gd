extends TextureButton

@onready var label: Label = $Label


func _on_button_down() -> void:
	label.add_theme_color_override("font_color"	, Color("1d1d4aff"))

func _on_button_up() -> void:
	label.add_theme_color_override("font_color", Color(1,1,1))

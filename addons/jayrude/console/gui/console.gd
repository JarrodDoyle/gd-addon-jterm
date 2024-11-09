extends CanvasLayer

@export var input: LineEdit
@export var output: RichTextLabel

var _enabled: bool = false
var _was_paused: bool
var _was_mouse_mode: Input.MouseMode


func _ready() -> void:
	input.connect("text_submitted", _on_text_submitted)
	Console.connect("printed", _on_console_printed)
	Console.add_command("clear", _clear_command, "Clears console output")
	hide()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("console_toggle"):
		_enabled = !_enabled
		if _enabled:
			_was_paused = get_tree().paused
			_was_mouse_mode = Input.mouse_mode
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().paused = true
			show()
			input.grab_focus()
		else:
			Input.set_mouse_mode(_was_mouse_mode)
			get_tree().paused = _was_paused
			input.text = ""
			hide()


func _on_text_submitted(text: String) -> void:
	output.append_text("$ [color=gray]%s[/color]\n" % text)
	Console.execute(text)
	input.text = ""


func _on_console_printed(text: String) -> void:
	output.append_text(text)


func _clear_command() -> void:
	output.text = ""

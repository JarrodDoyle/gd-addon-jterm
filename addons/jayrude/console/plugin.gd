@tool
class_name JayrudeConsole
extends EditorPlugin

const AUTOLOAD_NAME := "Console"
const AUTOLOAD_PATH := "res://addons/jayrude/console/service/console_service.gd"

func _enter_tree() -> void:
	add_autoload_singleton(AUTOLOAD_NAME, AUTOLOAD_PATH)
	add_action("console_toggle", [KEY_QUOTELEFT])


func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_NAME)


func add_action(name: String, inputs) -> void:
	# Apparently InputMap stuff doesn't work in plugins :)
	var setting_name := "input/%s" % name
	if ProjectSettings.has_setting(setting_name):
		return
	
	var events :=  []
	for input in inputs:
		var event = InputEventKey.new()
		event.keycode = input
		events.push_back(event)
	
	ProjectSettings.set_setting(setting_name, {"deadzone": 0.5, "events": events})
	ProjectSettings.save()
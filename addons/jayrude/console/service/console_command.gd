class_name ConsoleCommand
extends RefCounted

var name: StringName
var description: String
var args: Array[Dictionary]
var num_default_args: int
var _function: Callable


func _init(name: StringName, function: Callable, description: String) -> void:
	name = name
	_function = function
	self.description = description

	var method_info: Dictionary = _get_method_info(_function)
	args = method_info["args"]
	num_default_args = Array(method_info["default_args"]).size()


func _get_method_info(function: Callable) -> Dictionary:
	var method_info: Dictionary    = {}
	var methods: Array[Dictionary] = function.get_object().get_method_list()
	var method_name: StringName    = function.get_method()

	for m in methods:
		if m["name"] == method_name:
			method_info = m
			break
	return method_info


func _convert_arg(arg: String, type: int) -> Variant:
	if [TYPE_NIL, TYPE_STRING, TYPE_STRING_NAME].has(type):
		return arg
	elif type == TYPE_INT and arg.is_valid_int():
		return arg.to_int()
	elif type == TYPE_FLOAT and arg.is_valid_float():
		return arg.to_float()
	elif type == TYPE_BOOL:
		if arg == "true":
			return true
		elif arg == "false":
			return false
		elif arg.is_valid_int():
			return arg.to_int()

	return null


func execute(exec_args: PackedStringArray) -> String:
	var num_args: int = exec_args.size()
	var max_args: int = args.size()
	var min_args: int = max_args - num_default_args
	if num_args > max_args or num_args < min_args:
		return "Invalid argument count: %s received, %s to %s expected." % [num_args, min_args, max_args]

	var call_args: Array = []
	for i in num_args:
		call_args.push_back(_convert_arg(exec_args[i], args[i]["type"]))

	var result = _function.callv(call_args)
	return result if result is String else ""

# TODO: Transparent errors to the user
class_name ConsoleService
extends Node

signal printed(string: String)
var _commands: Dictionary


func _ready() -> void:
	add_command("help", _command_help, "Prints all registered commands and their description")
	add_command("example", _command_example, "Example command")


func _print(string: String) -> void:
	printed.emit(string  + "\n")


func has_command(name: String) -> bool:
	return _commands.has(name)


func add_command(name: String, function: Callable, description: String = "") -> void:
	if not has_command(name):
		_commands[name] = ConsoleCommand.new(name, function, description)


func remove_command(name: String) -> void:
	_commands.erase(name)


func list_commands() -> PackedStringArray:
	return _commands.keys()


func execute(input: String) -> void:
	var tokens: PackedStringArray = input.split(" ", false)
	if tokens.is_empty():
		return

	var name: String            = tokens[0]
	var args: PackedStringArray = tokens.slice(1)
	if has_command(name):
		var result: String = _commands[name].execute(args)
		if not result.is_empty():
			_print(result)
	else:
		_print("Command not found")


func _command_help() -> String:
	var output  := "[color=bisque]Commands:[/color]"
	var max_len := 0

	var arg_strings: Array[String] = []
	var arg_descs: Array[String]   = []
	for name in list_commands():
		var command := _commands[name] as ConsoleCommand

		var arg_string := ""
		arg_string += "[color=greenyellow]%s[/color]" % name
		arg_string += "[color=gray]"

		var args_left := command.args.size()
		for arg: Dictionary in command.args:
			arg_string += " "
			if args_left == command.num_default_args:
				arg_string += "("

			arg_string += "%s:" % arg["name"]
			var arg_type: int = arg["type"]
			match arg_type:
				TYPE_NIL: arg_string += "Nil"
				TYPE_STRING: arg_string += "String"
				TYPE_STRING_NAME: arg_string += "String"
				TYPE_INT: arg_string += "Int"
				TYPE_FLOAT: arg_string += "Float"
				TYPE_BOOL: arg_string += "Bool"
				_: arg_string += "Unknown"
			args_left -= 1

		if command.num_default_args > 0:
			arg_string += ")"
		arg_string += "[/color]"
		arg_strings.append(arg_string)
		arg_descs.append(command.description)

		if arg_string.length() > max_len:
			max_len = arg_string.length()

	for i in arg_strings.size():
		var arg_string := arg_strings[i].rpad(max_len + 2, " ")
		var arg_desc   := arg_descs[i]
		output += "\n[code] %s [/code] %s" % [arg_string, arg_desc]

	return output


func _command_example(arg1: int, arg2: String, arg3: bool = false) -> void:
	pass

# TODO: Transparent errors to the user
class_name ConsoleService
extends Node


signal printed(string: String)


var _commands: Dictionary


func _ready() -> void:
	add_command("help", _help, "Prints all registered commands and their description")


func _print(string: String) -> void:
	printed.emit(string  + "\n")


func has_command(name: String) -> bool:
	return _commands.has(name)


func add_command(name: String, function:  Callable, description: String = "") -> void:
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
		
	var name: String = tokens[0]
	var args: PackedStringArray = tokens.slice(1)
	if has_command(name):
		var result: String = _commands[name].execute(args)
		if not result.is_empty():
			_print(result)
	else:
		_print("Command not found")


func _help() -> String:
	var output := "Listing commands:"
	for name in list_commands():
		var command = _commands[name]
		output += "\n%s - %s" % [name, command.description]
	return output

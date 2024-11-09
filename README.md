<p align="center">
<img height="128" src="media/icon.png" alt="JTerm logo">
</p>

# JTerm

A simple in-game console system for Godot 4 with automated argument name and type recognition.

## Command registration

Console commands can be registered from any node in the scene, and should be unloaded whenever the node in question exits the tree to avoid lingering invalid commands.

```gdscript
func _ready() -> void:
    Console.add_command("example", _command_example, "Example command showcasing argument typing")

func _exit_tree() -> void:
    Console.remove_command("example")

func _command_example(arg, typed_arg: int, optional_arg: bool = true) -> void:
    # Do whatever you want!
    pass
```

Projects using C# can also register and call commands, however it's slightly more verbose and C# commands cannot make use of default arguments.

```csharp
public override void _Ready()
{
    var console = GetNode("/root/Console");
    var callable = new Callable(this, MethodName.Example);
    console.Call("add_command", "example_cs", callable, "C# Example");
}

// This optional arg unfortunately isn't actually optional :(
public void Example(Variant arg, int typed_arg, bool optional_arg = true)
{
    // Do stuff
}
```

## Console GUI

JTerm comes with a simple pre-built GUI scene that can be found at `addons/jayrude/console/gui/console.tscn`. The GUI is not autoloaded by default to allow you to build your own, or only enable it in certain circumstances.

![console_help_command](./media/screenshot1.png)

# GodotUIScroller

This Godot node is a simple UI scroller that supports both mouse and touchscreen movements for mobile. It also includes momentum, which means it will keep on moving when you let go of your mouse or finger. It is made to be as generic as possible.

# How to use

1. Add the component to your project.
2. Instanciate the node in your scene.
3. Resize the node to fit the area where you want the interaction.
4. In the parent scene, call the `InitializeScroller` function.
Ex:
```func _ready() -> void:
	$VerticalScroller.InitializeScroller($MapContainer, self)
 ```
 The first argument is the Target node, i.e. the control node that contains all the elements you want to scroll. The second argument is the parent node to that scrollable node.
 5. Tah-dah! You are done. Go try it out!

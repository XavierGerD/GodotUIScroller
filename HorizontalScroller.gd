extends TextureButton

var CurrentTarget

var IsClicked
var DeltaX
var TotalDisplacementX
var MousePosition
var LastMousePosition = 0
var DeltaPosition = 0
var DecelerationSpeed = 0.2
onready var MinWidth = 0

func InitializeScroller(Target):
	CurrentTarget = Target
	MinWidth = -1 * CurrentTarget.rect_size.x

func _process(_delta: float) -> void:
	if (!IsClicked && DeltaPosition != 0):
		CurrentTarget.set_position(Vector2(CurrentTarget.get_position().x + DeltaPosition, CurrentTarget.get_position().y))
		if (CurrentTarget.get_position().x < MinWidth):
			CurrentTarget.set_position(Vector2(MinWidth, CurrentTarget.get_position().y))
			DeltaPosition = 0
		if (CurrentTarget.get_position().x > 0):
			CurrentTarget.set_position(Vector2(0, CurrentTarget.get_position().y))
			DeltaPosition = 0
			
	if (!IsClicked && DeltaPosition > 0):
		if DeltaPosition - DecelerationSpeed < 0:
			DeltaPosition = 0
		else:
			DeltaPosition -= DecelerationSpeed
	if (!IsClicked && DeltaPosition < 0):
		if DeltaPosition + DecelerationSpeed > 0:
			DeltaPosition = 0
		else:
			DeltaPosition += DecelerationSpeed
			
			
func _input(event):
	MinWidth = -1 * CurrentTarget.rect_size.x
	var OSName = OS.get_name()
	if OSName == 'Android' || OSName == 'iOS':
		if event is InputEventScreenTouch:
			MousePosition = event.position.x
			DeltaX = MousePosition - CurrentTarget.get_position().x
		if event is InputEventScreenDrag:
			UpdatePositionWithFinger(event)
	else:
		UpdatePositionWithMouse(event)
		
func UpdatePositionWithFinger(event):
	if "position" in event:
		MousePosition = event.position.x
		if IsClicked:
			var Speed = event.get_speed().x / 40
			if Speed == 0:
				Speed = -150
				if MousePosition > LastMousePosition:
					Speed = 150
			DeltaPosition = Speed
			UpdatePosition(event)
				
func UpdatePositionWithMouse(event):
	if "position" in event:
		MousePosition = event.position.x
		if IsClicked:
			if (MousePosition != LastMousePosition):
				DeltaPosition = MousePosition - LastMousePosition
				LastMousePosition = MousePosition
				UpdatePosition(event)
				
func UpdatePosition(event):
	TotalDisplacementX = event.position.x - DeltaX
	CurrentTarget.set_position(Vector2(TotalDisplacementX, CurrentTarget.get_position().y))
	if (CurrentTarget.get_position().x < MinWidth):
		CurrentTarget.set_position(Vector2(MinWidth, CurrentTarget.get_position().y))
	if (CurrentTarget.get_position().x > 0):
		CurrentTarget.set_position(Vector2(0, CurrentTarget.get_position().y))


func _on_Scroller_button_down() -> void:
	DeltaX = MousePosition - CurrentTarget.get_position().x
	DeltaPosition = 0
	LastMousePosition = MousePosition
	IsClicked = true

func _on_Scroller_button_up() -> void:
	IsClicked = false

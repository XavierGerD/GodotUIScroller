extends TextureButton

var CurrentTarget
var CurrentTargetParent

var IsClicked
var DeltaY = 0
var TotalDisplacementY
var MousePosition = 0
var LastMousePosition = 0
var DeltaPosition = 0
var DecelerationSpeed = 0.2
onready var MinHeight = 0

func InitializeScroller(Target, TargetParent):
	CurrentTarget = Target
	CurrentTargetParent = TargetParent
	MinHeight = -1 * CurrentTarget.rect_size.y

func _process(_delta: float) -> void:
	if (!IsClicked && DeltaPosition != 0):
		CurrentTarget.set_position(Vector2(CurrentTarget.get_position().x, CurrentTarget.get_position().y + DeltaPosition))
		if (CurrentTarget.get_position().y < MinHeight):
			CurrentTarget.set_position(Vector2(CurrentTarget.get_position().x, MinHeight))
			DeltaPosition = 0
		if (CurrentTarget.get_position().y > 0):
			CurrentTarget.set_position(Vector2(CurrentTarget.get_position().x, 0))
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
	MinHeight = -1 * CurrentTarget.rect_size.y + CurrentTargetParent.rect_size.y
	var OSName = OS.get_name()
	if OSName == 'Android' || OSName == 'iOS':
		if event is InputEventScreenTouch:
			MousePosition = event.position.y
			DeltaY = MousePosition - CurrentTarget.get_position().y
		if event is InputEventScreenDrag:
			
			UpdatePositionWithFinger(event)
	else:
		UpdatePositionWithMouse(event)
		
func UpdatePositionWithFinger(event):
	if "position" in event:
		MousePosition = event.position.y
		if IsClicked:
			var Speed = event.get_speed().y / 40
			if Speed == 0:
				Speed = -150
				if MousePosition > LastMousePosition:
					Speed = 150
			DeltaPosition = Speed
			UpdatePosition(event)
				
func UpdatePositionWithMouse(event):
	if "position" in event:
		MousePosition = event.position.y
		if IsClicked:
			if (MousePosition != LastMousePosition):
				DeltaPosition = MousePosition - LastMousePosition
				LastMousePosition = MousePosition
				UpdatePosition(event)
				
func UpdatePosition(event):
		TotalDisplacementY = event.position.y - DeltaY
		CurrentTarget.set_position(Vector2(CurrentTarget.get_position().x, TotalDisplacementY))
		if (CurrentTarget.get_position().y < MinHeight):
			CurrentTarget.set_position(Vector2(CurrentTarget.get_position().x, MinHeight))
		if (CurrentTarget.get_position().y > 0):
			CurrentTarget.set_position(Vector2(CurrentTarget.get_position().x, 0))
			
func _on_Scroller_button_down() -> void:
	DeltaY = MousePosition - CurrentTarget.get_position().y
	DeltaPosition = 0
	LastMousePosition = MousePosition
	IsClicked = true

func _on_Scroller_button_up() -> void:
	IsClicked = false

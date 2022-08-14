extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Here create a reference to the `_on_get` function (below).
# This reference will be kept until the node is freed.
var _callback = JavaScript.create_callback(self, "_on_get")


# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the `window` object, where globally defined functions are.
	var window = JavaScript.get_interface("window")
	# Call the JavaScript `myFunc` function defined in the custom HTML head.
	window.goDotJSChannel("GoDot inizialized :)")
	# Get the `axios` library (loaded from a CDN in the custom HTML head).
	var axios = JavaScript.get_interface("axios")
	# Make a GET request to the current location, and receive the callback when done.
	axios.get(window.location.toString()).then(_callback)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_get(args):
	OS.alert("GoDot Callback"+args)

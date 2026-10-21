# log in page
extends Control

# town scene
const TOWN_SCENE := "res://Scenes/main_town.tscn"

# log in page modes
enum Mode { CHOOSE, LOG_IN, SIGN_UP }

var _mode := Mode.CHOOSE


# set up the log in page
func _ready() -> void:
	%Email.virtual_keyboard_type = LineEdit.KEYBOARD_TYPE_EMAIL_ADDRESS
	%Password.virtual_keyboard_type = LineEdit.KEYBOARD_TYPE_PASSWORD

	# buttons
	%LogInButton.pressed.connect(_show_mode.bind(Mode.LOG_IN))
	%SignUpButton.pressed.connect(_show_mode.bind(Mode.SIGN_UP))
	%BackButton.pressed.connect(_show_mode.bind(Mode.CHOOSE))
	%SubmitButton.pressed.connect(_on_submit_pressed)

	%Password.text_submitted.connect(func(_text): _on_submit_pressed())

	_show_mode(Mode.CHOOSE)

	# auto log in
	if Auth.has_saved_session():
		_set_busy(true, "Signing you back in...")
		if await Auth.restore_session():
			_go_to_town()
			return
		_set_busy(false, "")


# switch pages
func _show_mode(mode: Mode) -> void:
	_mode = mode

	%StartButtons.visible = mode == Mode.CHOOSE
	%Form.visible = mode != Mode.CHOOSE

	%Username.visible = mode == Mode.SIGN_UP
	%SubmitButton.text = "Create Account" if mode == Mode.SIGN_UP else "Log In"

	# page text
	%Subtitle.text = {
		Mode.CHOOSE: "Welcome, traveler! Log in or create an account to start exploring.",
		Mode.LOG_IN: "Welcome back!",
		Mode.SIGN_UP: "Pick a username for your adventure.",
	}[mode]

	%Password.text = ""
	%Status.text = ""


# log in / sign up button
func _on_submit_pressed() -> void:
	if %SubmitButton.disabled:
		return

	_set_busy(true, "Please wait...")
	var result: Dictionary
	if _mode == Mode.SIGN_UP:
		result = await Auth.sign_up(%Username.text, %Email.text, %Password.text)
	else:
		result = await Auth.sign_in(%Email.text, %Password.text)

	_set_busy(false, result.message)

	if Auth.is_logged_in():
		_go_to_town()
	elif result.ok:

		_show_mode(Mode.LOG_IN)
		%Status.text = result.message


# lock buttons while loading
func _set_busy(busy: bool, message: String) -> void:
	for button in [%LogInButton, %SignUpButton, %SubmitButton, %BackButton]:
		button.disabled = busy
	%Status.text = message


# go to town
func _go_to_town() -> void:
	%Password.text = ""
	get_tree().change_scene_to_file(TOWN_SCENE)

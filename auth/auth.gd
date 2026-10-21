# login and sign up with supabase
extends Node

# tells other scenes when someone logs in or out
signal session_changed(logged_in: bool)

# saved login file
const SESSION_PATH := "user://session.dat"
# username and password rules
const USERNAME_REGEX := "^[A-Za-z0-9_]{3,20}$"
const MIN_PASSWORD_LENGTH := 8

# player info
var user_id := ""
var username := ""
var email := ""

# login tokens
var _access_token := ""
var _refresh_token := ""
var _expires_at := 0.0


# check if logged in
func is_logged_in() -> bool:
	return _refresh_token != ""


# check for saved login
func has_saved_session() -> bool:
	return FileAccess.file_exists(SESSION_PATH)


# username check
static func validate_username(value: String) -> String:
	var regex := RegEx.create_from_string(USERNAME_REGEX)
	if regex.search(value) == null:
		return "Username must be 3-20 letters, numbers, or underscores."
	return ""


# email check
static func validate_email(address: String) -> String:
	var regex := RegEx.create_from_string("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")
	if regex.search(address) == null:
		return "Please enter a valid email address."
	return ""


# password check
static func validate_password(password: String) -> String:
	if password.length() < MIN_PASSWORD_LENGTH:
		return "Password must be at least %d characters." % MIN_PASSWORD_LENGTH
	return ""


# create account
func sign_up(new_username: String, new_email: String, password: String) -> Dictionary:
	new_username = new_username.strip_edges()
	new_email = new_email.strip_edges().to_lower()

	for error in [validate_username(new_username), validate_email(new_email), validate_password(password)]:
		if error != "":
			return _fail(error)

	# make sure username isnt taken
	var check := await _request("/rest/v1/rpc/username_available", HTTPClient.METHOD_POST, {"name": new_username})
	if not check.ok:
		return _fail(check.error)
	if check.data != true:
		return _fail("That username is already taken.")

	var res := await _request("/auth/v1/signup", HTTPClient.METHOD_POST, {
		"email": new_email,
		"password": password,
		"data": {"username": new_username},
	})
	if not res.ok:
		return _fail(res.error)

	if not res.data.has("access_token"):
		return {"ok": true, "message": "Account created! Check your email to confirm it, then log in."}

	_apply_session(res.data)
	return {"ok": true, "message": "Welcome, %s!" % username}


# log in
func sign_in(login_email: String, password: String) -> Dictionary:
	login_email = login_email.strip_edges().to_lower()
	if validate_email(login_email) != "" or password.is_empty():
		return _fail("Please enter your email and password.")

	var res := await _request("/auth/v1/token?grant_type=password", HTTPClient.METHOD_POST, {
		"email": login_email,
		"password": password,
	})
	if not res.ok:
		return _fail(res.error)
	_apply_session(res.data)
	return {"ok": true, "message": "Welcome back, %s!" % username}


# auto log in
func restore_session() -> bool:
	var saved := _load_session()
	if saved.is_empty():
		return false
	_refresh_token = saved.get("refresh_token", "")
	return await _refresh()


# log out
func sign_out() -> void:
	if _access_token != "":
		await _request("/auth/v1/logout", HTTPClient.METHOD_POST, {}, _access_token)
	_clear_session()


# token for database calls
func get_access_token() -> String:
	if not is_logged_in():
		return ""

	if Time.get_unix_time_from_system() > _expires_at - 60.0:
		if not await _refresh():
			return ""
	return _access_token


# refresh login
func _refresh() -> bool:
	var res := await _request("/auth/v1/token?grant_type=refresh_token", HTTPClient.METHOD_POST, {
		"refresh_token": _refresh_token,
	})
	if not res.ok:

		if res.code >= 400 and res.code < 500:
			_clear_session()
		return false
	_apply_session(res.data)
	return true


# save login info
func _apply_session(data: Dictionary) -> void:
	_access_token = data.get("access_token", "")
	_refresh_token = data.get("refresh_token", "")
	_expires_at = Time.get_unix_time_from_system() + float(data.get("expires_in", 3600))

	var user: Dictionary = data.get("user", {})
	user_id = user.get("id", "")
	email = user.get("email", "")
	username = user.get("user_metadata", {}).get("username", "")
	_save_session()
	session_changed.emit(true)


# clear login info
func _clear_session() -> void:
	var was_logged_in := is_logged_in()
	_access_token = ""
	_refresh_token = ""
	_expires_at = 0.0
	user_id = ""
	username = ""
	email = ""
	if FileAccess.file_exists(SESSION_PATH):
		DirAccess.remove_absolute(SESSION_PATH)
	if was_logged_in:
		session_changed.emit(false)


# password for the saved file
func _session_key() -> String:
	var device_id := "" if OS.has_feature("web") else OS.get_unique_id()
	return (device_id + "walking-worlds-session").sha256_text()


# save login to device
func _save_session() -> void:
	var file := FileAccess.open_encrypted_with_pass(SESSION_PATH, FileAccess.WRITE, _session_key())
	if file == null:
		push_warning("Could not save session: %s" % error_string(FileAccess.get_open_error()))
		return
	file.store_string(JSON.stringify({"refresh_token": _refresh_token}))


# load login from device
func _load_session() -> Dictionary:
	if not has_saved_session():
		return {}
	var file := FileAccess.open_encrypted_with_pass(SESSION_PATH, FileAccess.READ, _session_key())
	if file == null:
		_clear_session()
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	return parsed if parsed is Dictionary else {}


# error result
func _fail(message: String) -> Dictionary:
	return {"ok": false, "message": message}


# database connection
func _request(path: String, method: HTTPClient.Method, body: Dictionary, bearer := "") -> Dictionary:
	if not AuthConfig.is_configured():
		return {"ok": false, "code": 0, "data": null, "error": "Server not set up yet: fill in auth/auth_config.gd."}

	var headers := PackedStringArray([
		"Content-Type: application/json",
		"apikey: " + AuthConfig.SUPABASE_ANON_KEY,
	])
	if bearer != "":
		headers.append("Authorization: Bearer " + bearer)

	var http := HTTPRequest.new()
	http.timeout = 15.0
	add_child(http)
	var err := http.request(AuthConfig.SUPABASE_URL + path, headers, method, JSON.stringify(body))
	if err != OK:
		http.queue_free()
		return {"ok": false, "code": 0, "data": null, "error": "Could not start the request."}

	var result: Array = await http.request_completed
	http.queue_free()
	var status: int = result[0]
	var code: int = result[1]
	var raw: PackedByteArray = result[3]

	if status != HTTPRequest.RESULT_SUCCESS:
		return {"ok": false, "code": 0, "data": null, "error": "Can't reach the server. Check your internet connection."}

	var text := raw.get_string_from_utf8()
	var data = JSON.parse_string(text) if text != "" else {}
	if code >= 200 and code < 300:
		return {"ok": true, "code": code, "data": data, "error": ""}
	return {"ok": false, "code": code, "data": data, "error": _friendly_error(code, data)}


# error messages
func _friendly_error(code: int, data) -> String:
	var info: Dictionary = data if data is Dictionary else {}

	match str(info.get("error_code", info.get("error", ""))):
		"invalid_credentials", "invalid_grant":
			return "Wrong email or password."
		"email_not_confirmed":
			return "Please confirm your email first (check your inbox)."
		"user_already_exists", "email_exists":
			return "An account with that email already exists. Try logging in."
		"weak_password":
			return "That password is too weak. Try a longer one."
		"over_request_rate_limit", "over_email_send_rate_limit":
			return "Too many attempts. Please wait a minute and try again."

	if code == 429:
		return "Too many attempts. Please wait a minute and try again."
	if code >= 500:
		return "Server error. Please try again later."

	for key in ["msg", "error_description", "message"]:
		if info.has(key):
			return str(info[key])
	return "Something went wrong (error %d)." % code

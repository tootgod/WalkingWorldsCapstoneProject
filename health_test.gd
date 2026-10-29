extends Node

@export var steps_label: Label

const SAVE_PATH := "user://save.cfg"

var health
var total_steps: int = 0        
var last_step_count: int = 0    
var last_step_date: String = "" 
var is_refreshing := false

const POLL_INTERVAL := 5.0
var poll_timer: Timer

func start_polling():
	if poll_timer:
		return
	poll_timer = Timer.new()
	poll_timer.wait_time = POLL_INTERVAL
	poll_timer.one_shot = false
	poll_timer.timeout.connect(_on_poll_timeout)
	add_child(poll_timer)
	poll_timer.start()
	print("Polling started")


func _on_poll_timeout():
	refresh_steps()

func _ready():
	load_data()
	update_label()

	if not await setup_health():
		print("setup_health failed - polling not started")
		return

	print("setup_health OK - starting polling")
	await refresh_steps()
	start_polling()


func _notification(what):
	if not health:
		return
	if what == NOTIFICATION_APPLICATION_RESUMED:
		refresh_steps()
		if poll_timer:
			poll_timer.start()
	elif what == NOTIFICATION_APPLICATION_PAUSED:
		if poll_timer:
			poll_timer.stop()


func setup_health() -> bool:
	if not Engine.has_singleton("HealthConnect"):
		print("HealthConnect plugin NOT found")
		return false

	health = Engine.get_singleton("HealthConnect")
	health.updatePermissionStatus()
	await get_tree().create_timer(1.0).timeout

	if not health.hasStepPermission():
		print("Requesting permission...")
		health.requestStepPermission()

		for i in range(30):
			await get_tree().create_timer(1.0).timeout
			health.updatePermissionStatus()
			await get_tree().create_timer(0.2).timeout
			if health.hasStepPermission():
				break

	if not health.hasStepPermission():
		print("Step permission still NOT granted")
		return false

	return true


func refresh_steps():
	if is_refreshing:
		return
	is_refreshing = true

	health.updateTodaySteps()

	var waited := 0.0
	while not health.isTodayStepsReady() \
			and health.getLastError() == "" \
			and waited < 8.0:
		await get_tree().create_timer(0.3).timeout
		waited += 0.3

	var err: String = health.getLastError()
	if err != "":
		print("Health Connect ERROR: ", err)
		is_refreshing = false
		return

	if not health.isTodayStepsReady():
		print("Timed out waiting for steps")
		is_refreshing = false
		return

	var steps := int(health.getTodaySteps())
	print("Today's steps: ", steps)

	var new_steps := calculate_new_steps(steps)
	total_steps += new_steps
	print("New steps: ", new_steps, " / Total steps: ", total_steps)

	save_data()
	update_label()
	is_refreshing = false
	
	health.debugStepRecords()
	await get_tree().create_timer(1.5).timeout
	print("Raw records: ", health.getRawStepRecordCount())
	print("Raw total (7 days): ", health.getRawStepTotal())
	print("Raw sources: ", health.getRawStepSources())
	print("Last error: ", health.getLastError())


func calculate_new_steps(current_steps: int) -> int:
	var today = Time.get_date_string_from_system()

	if last_step_date == "":
		last_step_date = today
		last_step_count = current_steps
		return current_steps

	if last_step_date == today:
		var diff = current_steps - last_step_count
		if diff < 0:
			diff = 0
		last_step_count = max(last_step_count, current_steps)
		return diff

	last_step_date = today
	last_step_count = current_steps
	return current_steps


func get_score() -> int:
	return int(total_steps / 100)


func update_label():
	if steps_label:
		steps_label.text = "Score: " + str(get_score())


func save_data():
	var cfg = ConfigFile.new()
	cfg.set_value("save", "total_steps", total_steps)
	cfg.set_value("save", "last_step_count", last_step_count)
	cfg.set_value("save", "last_step_date", last_step_date)
	cfg.save(SAVE_PATH)


func load_data():
	var cfg = ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return
	total_steps = cfg.get_value("save", "total_steps", 0)
	last_step_count = cfg.get_value("save", "last_step_count", 0)
	last_step_date = cfg.get_value("save", "last_step_date", "")
	

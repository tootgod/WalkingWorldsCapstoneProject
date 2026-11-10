extends Node

@export var steps_label: Label
@export var walking_quest: Quest
@export var quest_progress_label: Label
@export var accept_quest_button: Button

signal steps_updated

var quest_active: bool = false
var quest_completed: bool = false
var quest_progress: int = 0
var quest_date: String = ""

var step_data_ready: bool = false

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
	_reset_daily_quest_if_needed()
	update_label()

	if accept_quest_button:
		if not accept_quest_button.pressed.is_connected(accept_walking_quest):
			accept_quest_button.pressed.connect(accept_walking_quest)

	update_quest_ui()

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

	_reset_daily_quest_if_needed()
	var new_steps := calculate_new_steps(steps)
	total_steps += new_steps
	add_quest_steps(new_steps)

	step_data_ready = true

	print("New steps: ", new_steps, " / Total steps: ", total_steps)

	save_data()
	update_label()
	update_quest_ui()
	is_refreshing = false
	steps_updated.emit()
	
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

	
func accept_walking_quest() -> void:
	if walking_quest == null:
		return

	if quest_active or quest_completed:
		return

	if not step_data_ready or is_refreshing:
		print("걸음 데이터를 불러오는 중입니다. 잠시 후 다시 눌러주세요.")
		return

	quest_active = true
	quest_progress = 0

	save_data()
	update_quest_ui()


func add_quest_steps(amount: int) -> void:
	if walking_quest == null or not quest_active:
		return

	quest_progress = mini(
		quest_progress + maxi(amount, 0),
		walking_quest.target_steps
	)

	if quest_progress >= walking_quest.target_steps:
		quest_active = false
		quest_completed = true
		print("1마일 걷기 퀘스트 완료!")


func update_quest_ui() -> void:
	if walking_quest == null:
		if quest_progress_label:
			quest_progress_label.text = "퀘스트를 연결해주세요."
		if accept_quest_button:
			accept_quest_button.disabled = true
		return

	var status := "수락 전"

	if quest_completed:
		status = "완료!"
	elif quest_active:
		status = "진행 중"

	if quest_progress_label:
		quest_progress_label.text = "%s\n%s\n%d / %d 걸음\n%s" % [
			walking_quest.name,
			walking_quest.description,
			quest_progress,
			walking_quest.target_steps,
			status
		]

	if accept_quest_button:
		accept_quest_button.disabled = (
			quest_active or quest_completed or not step_data_ready
		)

		if quest_completed:
			accept_quest_button.text = "완료!"
		elif quest_active:
			accept_quest_button.text = "진행 중"
		elif not step_data_ready:
			accept_quest_button.text = "걸음 데이터 연결 중"
		else:
			accept_quest_button.text = "수락"
		
func save_data():
	var cfg = ConfigFile.new()

	cfg.set_value("save", "total_steps", total_steps)
	cfg.set_value("save", "last_step_count", last_step_count)
	cfg.set_value("save", "last_step_date", last_step_date)

	cfg.set_value("mile_quest", "active", quest_active)
	cfg.set_value("mile_quest", "completed", quest_completed)
	cfg.set_value("mile_quest", "progress", quest_progress)
	cfg.set_value("mile_quest", "date", quest_date)

	var error := cfg.save(SAVE_PATH)
	if error != OK:
		push_error("저장 실패: %s" % error)


func load_data():
	var cfg = ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return

	total_steps = int(cfg.get_value("save", "total_steps", 0))
	last_step_count = int(cfg.get_value("save", "last_step_count", 0))
	last_step_date = str(cfg.get_value("save", "last_step_date", ""))

	quest_active = bool(cfg.get_value("mile_quest", "active", false))
	quest_completed = bool(cfg.get_value("mile_quest", "completed", false))
	quest_progress = int(cfg.get_value("mile_quest", "progress", 0))
	quest_date = str(cfg.get_value("mile_quest", "date", last_step_date))

func _reset_daily_quest_if_needed() -> void:
	var today := Time.get_date_string_from_system()
	if quest_date == today:
		return

	quest_date = today
	quest_active = false
	quest_completed = false
	quest_progress = 0
	save_data()

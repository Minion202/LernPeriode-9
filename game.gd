extends Node

@onready var http = $HTTPRequest
@onready var panel = $CanvasLayer/Panel
@onready var name_input = $CanvasLayer/Panel/VBoxContainer/NameInput
@onready var save_button = $CanvasLayer/Panel/VBoxContainer/SaveButton
@onready var leaderboard_list = $CanvasLayer/Panel/VBoxContainer/LeaderboardList

var coins = 0
var last_call = ""

func _ready():
	print("READY")
	http.request_completed.connect(_on_done)
	panel.visible = false

func add_coin(amount: int = 1) -> void:
	coins += amount
	print("COINS AKTUELL:", coins)

func game_over() -> void:
	print("GAME OVER")
	panel.visible = true
	name_input.grab_focus()
	fetch_leaderboard()

func _input(event):
	if panel.visible:
		return

	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_P:
			game_over()

func submit_score(player: String, score: int) -> void:
	print("SUBMIT SCORE START")
	last_call = "score"
	var url = "http://127.0.0.1:8000/score"
	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify({"player": player, "score": score})
	var err = http.request(url, headers, HTTPClient.METHOD_POST, body)
	print("submit_score request_err:", err)

func fetch_leaderboard() -> void:
	print("FETCH LEADERBOARD START")
	last_call = "leaderboard"
	var url = "http://127.0.0.1:8000/leaderboard"
	var err = http.request(url)
	print("fetch_leaderboard request_err:", err)

func _on_done(result, response_code, headers, body):
	var text = body.get_string_from_utf8()
	print("HTTP RESPONSE CODE:", response_code)
	print("HTTP BODY:", text)
	print("LAST CALL:", last_call)

	if response_code != 200:
		print("FEHLER BEI:", last_call)
		return

	if last_call == "score":
		print("SCORE GESPEICHERT")
		fetch_leaderboard()
		return

	if last_call == "leaderboard":
		print("LEADERBOARD GELADEN")
		var data = JSON.parse_string(text)
		if typeof(data) != TYPE_ARRAY:
			print("leaderboard json not array")
			return
		show_leaderboard(data)

func show_leaderboard(data):
	print("SHOW LEADERBOARD")

	for child in leaderboard_list.get_children():
		child.queue_free()

	var title = Label.new()
	title.text = "TOP SCORES"
	leaderboard_list.add_child(title)

	var i = 1
	for row in data:
		var player = str(row.get("player", ""))
		var score = int(row.get("score", 0))

		var line = Label.new()
		line.text = str(i) + ".  " + player + "     " + str(score)
		leaderboard_list.add_child(line)
		i += 1

func _on_save_button_pressed() -> void:
	print("SAVE GEKLICKT")
	print("COINS BEIM SAVE:", coins)

	var player_name = name_input.text.strip_edges()
	print("NAME:", player_name)

	if player_name == "":
		player_name = "Player"

	submit_score(player_name, coins)

extends Node

@onready var http := $HTTPRequest

@onready var panel = $CanvasLayer/Panel
@onready var name_input = $CanvasLayer/Panel/VBoxContainer/NameInput
@onready var save_button = $CanvasLayer/Panel/VBoxContainer/SaveButton

var coins := 0
var last_call := ""

func _ready():
	http.request_completed.connect(_on_done)
	save_button.pressed.connect(_on_save_pressed)
	panel.visible = false

func add_coin(amount: int = 1) -> void:
	coins += amount
	print("coins:", coins)

func game_over() -> void:
	panel.visible = true
	name_input.text = ""
	name_input.grab_focus()

func _on_save_pressed() -> void:
	var player_name = name_input.text.strip_edges()
	if player_name == "":
		print("Name fehlt")
		return

	submit_score(player_name, coins)

func submit_score(player: String, score: int) -> void:
	last_call = "score"
	var url := "http://127.0.0.1:8000/score"
	var headers := ["Content-Type: application/json"]
	var body := JSON.stringify({"player": player, "score": score})
	var err = http.request(url, headers, HTTPClient.METHOD_POST, body)
	print("submit_score request_err:", err)

func fetch_leaderboard() -> void:
	last_call = "leaderboard"
	var url := "http://127.0.0.1:8000/leaderboard"
	var err = http.request(url)
	print("fetch_leaderboard request_err:", err)

func _on_done(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var text := body.get_string_from_utf8()
	print("status:", response_code)
	print("body:", text)

	if response_code != 200:
		print("error on:", last_call)
		return

	if last_call == "score":
		print("saved ok, now fetch leaderboard")
		panel.visible = false
		fetch_leaderboard()
		return

	if last_call == "leaderboard":
		var data = JSON.parse_string(text)
		if typeof(data) != TYPE_ARRAY:
			print("leaderboard json not array")
			return

		print("TOP SCORES")
		var i := 1
		for row in data:
			print(str(i) + ". " + str(row.get("player", "")) + "  " + str(row.get("score", 0)))
			i += 1
			
			
func _input(event):
	if event.is_action_pressed("ui_accept"):
		game_over()

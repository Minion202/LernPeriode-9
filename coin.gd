extends Area2D

func _on_body_entered(body):
	print("COIN BERÜHRT")

	var game = get_tree().get_first_node_in_group("game")
	print("GAME GEFUNDEN:", game)

	if game:
		game.add_coin(1)
		print("COIN AN GAME GESENDET")

	queue_free()

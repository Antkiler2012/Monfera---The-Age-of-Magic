extends Area2D

func _ready():
	randomize()
	start_random_check()

func start_random_check():
	while true:
		await get_tree().create_timer(5.0).timeout
		var num = randi_range(0, 10)
		if num == 1:
			print("The random number is 1!")
		else:
			print("Number was:", num)

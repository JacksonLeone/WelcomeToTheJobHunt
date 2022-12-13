extends Label


func _on_PointBuy_set_counter(pointTotal, pointsLeft):
	set_points(pointTotal, pointsLeft)
	

func set_points(pointTotal, pointsLeft):
	self.text = str(pointsLeft) + "/" + str(pointTotal) + " points total"

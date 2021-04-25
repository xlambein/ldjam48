class_name Globals
extends Reference

enum TrainingLabel {
	PUPPER,
	TRUCK,
}

static func random_label() -> int:
	return TrainingLabel.values()[randi() % TrainingLabel.size()]

extends Node

signal shake_requested(intensity: float, duration: float)

func request_shake(intensity: float, duration: float):
    print("SHAKE")
    shake_requested.emit(intensity, duration)
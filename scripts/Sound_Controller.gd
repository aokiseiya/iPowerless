extends Node

onready var sfxplayer = get_node("SamplePlayer")
onready var bgmplayer = get_node("StreamPlayer")

func sfx(name):
	sfxplayer.play(name)

func bgm(name):
	if bgmplayer.is_playing():
		bgmplayer.stop()
	if name == "song1":
		bgmplayer.set_stream(load("res://assets/sounds/songs/song1.ogg"))
		bgmplayer.play()
	elif name == "song2":
		bgmplayer.set_stream(load("res://assets/sounds/songs/song2.ogg"))
		bgmplayer.play()

func _ready():
	bgm("song1")

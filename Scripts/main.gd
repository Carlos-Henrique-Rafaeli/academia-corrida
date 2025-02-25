extends Control

@onready var dadoTexture = $DadoTexture
@onready var progressoCpu = $VBoxContainer/ProgressBar1
@onready var progressoPlayer = $VBoxContainer/ProgressBar2
@onready var cpuLabel = $VBoxContainer/PositionLabel1
@onready var playerLabel = $VBoxContainer/PositionLabel2
@onready var winLabel = $WinLabel
@onready var regras = $RegrasPanel
@onready var statsLabel = $StatsLabel1
@onready var colorTurn = $ColorTurn
@onready var CPUTimer = $CPUTimer


var player : int = 0
var cpu : int = 0

var is_round_player : bool = true


func _ready() -> void:
	randomize()


func _jogar_dado() -> int:
	var dado = randi_range(1, 6)
	var new_texture = "res://Texturas/%s.png" % dado
	dadoTexture.texture = load(new_texture)
	return dado


func _round_player():
	var dado = _jogar_dado()
	
	progressoPlayer.value += dado
	
	if progressoPlayer.value >= 30:
		winLabel.visible = true
		winLabel.label_settings.font_color = Color8(50, 255, 50)
		winLabel.text = "Você Venceu!"
		playerLabel.text = "Posição: %s" % 30
		return
	
	if progressoPlayer.value == 5 or progressoPlayer.value == 10 or progressoPlayer.value == 15:
		progressoPlayer.value += 3
		dado += 3
	elif progressoPlayer.value == 7 or progressoPlayer.value == 13 or progressoPlayer.value == 20:
		progressoPlayer.value -= 2
		dado -= 2
	
	if dado >= 0:
		statsLabel.text = "Andou: %s" % dado
	else:
		statsLabel.text = "Voltou: %s" % abs(dado)
	
	playerLabel.text = "Posição: %s" % progressoPlayer.value
	
	if dado == 6:
		is_round_player = true
	else:
		is_round_player = false
		colorTurn.position = Vector2(384, 138)
		CPUTimer.start(randi_range(1, 3))


func _round_cpu():
	var dado = _jogar_dado()
	
	progressoCpu.value += dado
	
	if progressoCpu.value >= 30:
		winLabel.visible = true
		winLabel.label_settings.font_color = Color8(255, 50, 50)
		winLabel.text = "Você Perdeu!"
		cpuLabel.text = "Posição: %s" % 30
		return
	
	if progressoCpu.value == 5 or progressoCpu.value == 10 or progressoCpu.value == 15:
		progressoCpu.value += 3
		dado += 3
	elif progressoCpu.value == 7 or progressoCpu.value == 13 or progressoCpu.value == 20:
		progressoCpu.value -= 2
		dado -= 2
	
	if dado >= 0:
		statsLabel.text = "Andou: %s" % dado
	else:
		statsLabel.text = "Voltou: %s" % abs(dado)
	
	cpuLabel.text = "Posição: %s" % progressoCpu.value
	
	if dado == 6:
		is_round_player = false
		CPUTimer.start(randi_range(1, 3))
	else:
		is_round_player = true
		colorTurn.position = Vector2(384, 362)

func _on_button_pressed() -> void:
	if is_round_player and winLabel.visible == false:
		_round_player()


func _on_replay_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_rules_button_pressed() -> void:
	regras.visible = not regras.visible


func _on_cpu_timer_timeout() -> void:
	_round_cpu()

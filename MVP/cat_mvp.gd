extends Control

signal cat_satisfied(cat)


var REACTION_ICONS = { 
	"like": load("res://Arts/reaction_like.png"), 
	"dislike": load("res://Arts/reaction_uninterested.png")
}

# cat audio
var MEOW_LIST = [
	preload('res://Audios/meow_clip_1.wav'),
	preload('res://Audios/meow_clip_2.wav'),
	preload('res://Audios/meow_clip_3.wav')
]

var MAX_SCORE = 3

var cat_data = null
var reaction_enabled = true
var satisfaction = 0

@onready var cat_shader = $CatAnimation.material


# Called when the node enters the scene tree for the first time.
func _ready():
	$Bubble.hide()
	fade_in()


# fade in and out effect with shader
func fade_in():
	var tween = create_tween()
	cat_shader.set_shader_parameter("fade_amount", 0.0)
	tween.tween_property(cat_shader, "shader_parameter/fade_amount", 1.0, 0.8)


func fade_out():
	
	var tween = create_tween()
	cat_shader.set_shader_parameter("fade_amount", 1.0)
	tween.tween_property(cat_shader, "shader_parameter/fade_amount", 0.0, 0.5)
	
	# delete cat node
	tween.tween_callback(queue_free)


# Get cat data attributes
func get_cat_data(attr = null):
	if attr:
		return cat_data.get(attr)
	return cat_data
	
	
# Update cat data and appearance
func set_cat_data(data):
	cat_data = data
	var animation = cat_data.id + "_" + cat_data.status
	$CatAnimation.play(animation)
	$CatStatus.show_visit_count(cat_data.visits)


# specify behavior when being dropped on
func _can_drop_data(position, data):
	return data.has("greet_item")


func _drop_data(position, data):
	var menu_item = data["greet_item"]
	print("Cat received ", menu_item.name)
	await show_reaction(menu_item)


# Show cat reaction 
func show_reaction(menu_item):
	
	# get cat preference score
	var like_score = cat_data[menu_item.get_item_data("id")]
	satisfaction += like_score
	
	# change display bar length
	if satisfaction < 0:
		satisfaction = 0
	var score_percent = satisfaction * 100 / MAX_SCORE
	if score_percent > 100:
		score_percent = 100
	$CatStatus.run_bar_animation(score_percent)
	
	# choose reaction icon based on score
	var reaction
	if like_score > 0:
		reaction = "like"
	else:
		reaction = "dislike"

	$Bubble/ReactionIcon.texture = REACTION_ICONS[reaction]
	
	# display reaction and temporarily disable click signals on cat
	reaction_enabled = false
	$Bubble.show()
	await get_tree().create_timer(1).timeout
	$Bubble.hide()
	reaction_enabled = true
	
	# check satisfaction
	if satisfaction >= MAX_SCORE:
		$ReactionSound.stream = MEOW_LIST.pick_random()
		$ReactionSound.play()
		emit_signal("cat_satisfied", self)
		

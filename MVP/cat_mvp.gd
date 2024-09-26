extends Control

signal cat_satisfied(cat)


var reaction_icons = { 
	"like": load("res://Arts/reaction_like.png"), 
	"dislike": load("res://Arts/reaction_uninterested.png"), 
	"neutral": load("res://Arts/reaction_question.png")
}

var MAX_SCORE = 10

var cat_data = null
var reaction_enabled = true
var satisfaction = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$Bubble.hide()


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
	var like_score
	if menu_item.name == 'Petting':
		like_score = cat_data["pet"]
	else: 
		like_score = cat_data["food"][menu_item.name]
	
	satisfaction += like_score
	
	# change display bar length
	var score_percent = satisfaction * 100 / MAX_SCORE
	if score_percent > 100:
		score_percent = 100
	$CatStatus.run_bar_animation(score_percent)
	
	# choose reaction icon based on score
	var reaction
	if like_score > 0:
		reaction = "like"
	elif like_score == 0:
		reaction = "neutral"
	else:
		reaction = "dislike"

	$Bubble/ReactionIcon.texture = reaction_icons[reaction]
	
	# display reaction and temporarily disable click signals on cat
	reaction_enabled = false
	$Bubble.show()
	await get_tree().create_timer(1).timeout
	$Bubble.hide()
	reaction_enabled = true
	
	# check satisfaction
	if satisfaction >= MAX_SCORE:
		emit_signal("cat_satisfied", self)
		
	if satisfaction < 0:
		pass
		

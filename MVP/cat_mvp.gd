extends Control

signal cat_greeted(cat, menu_item)


var reaction_icons = { 
	"like": load("res://Arts/reaction_like.png"), 
	"dislike": load("res://Arts/reaction_uninterested.png"), 
	"neutral": load("res://Arts/reaction_question.png"),
	"idle": load("res://Arts/reaction_question.png")
}

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
	emit_signal("cat_greeted", self, menu_item)


# Decide cat reaction based on preference score
func get_reaction(score):
	
	# to do: check satisfaction after update
	satisfaction += score
	
	if score == null:
		return "idle"
	elif score > 0:
		return "like"
	elif score == 0:
		return "neutral"
	else:
		return "dislike"


# Show cat reaction 
func show_reaction(reaction):
	$Bubble/ReactionIcon.texture = reaction_icons[reaction]
	
	# display reaction and temporarily disable click signals on cat
	reaction_enabled = false
	$Bubble.show()
	await get_tree().create_timer(1).timeout
	$Bubble.hide()
	reaction_enabled = true

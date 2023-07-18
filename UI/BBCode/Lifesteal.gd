extends RichTextEffect
class_name RichTextLifesteal


const COLOR: Color = Color("red")

var bbcode = "lifesteal"


func _process_custom_fx(char_fx: CharFXTransform):
	char_fx.color = COLOR
	return true

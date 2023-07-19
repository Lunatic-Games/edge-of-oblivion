extends RichTextEffect
class_name RichTextKnockback


const COLOR: Color = Color("orange")

var bbcode = "knockback"


func _process_custom_fx(char_fx: CharFXTransform):
	char_fx.color = COLOR
	return true

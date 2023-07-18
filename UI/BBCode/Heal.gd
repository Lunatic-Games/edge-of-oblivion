extends RichTextEffect
class_name RichTextHeal


const COLOR: Color = Color("springgreen")

var bbcode = "heal"


func _process_custom_fx(char_fx: CharFXTransform):
	char_fx.color = COLOR
	return true

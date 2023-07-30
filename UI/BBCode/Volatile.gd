extends RichTextEffect
class_name RichTextVolatile


const COLOR: Color = Color("pink")

var bbcode = "volatile"


func _process_custom_fx(char_fx: CharFXTransform):
	char_fx.color = COLOR
	return true

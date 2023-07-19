extends RichTextEffect
class_name RichTextRange


const COLOR: Color = Color("pink")

var bbcode = "range"


func _process_custom_fx(char_fx: CharFXTransform):
	char_fx.color = COLOR
	return true

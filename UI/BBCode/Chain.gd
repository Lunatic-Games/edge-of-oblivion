extends RichTextEffect
class_name RichTextChain


const COLOR: Color = Color("cyan")

var bbcode = "chain"


func _process_custom_fx(char_fx: CharFXTransform):
	char_fx.color = COLOR
	return true

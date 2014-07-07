package ui
{
	import flash.text.TextDisplayMode;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class GenericTextfield extends TextField
	{
		private var _format:TextFormat;
		
		public function GenericTextfield(fontName:String, color:int, align:String, size:int)
		{
			_format = new TextFormat();
			_format.font = fontName;
			_format.color = color;
			_format.align = align;
			_format.size = size;
			
			autoSize = align;
			embedFonts = true;
			antiAliasType = TextDisplayMode.DEFAULT;
			selectable = false;
			setTextFormat(_format);	
		}
		
		public override function set text(value:String):void
		{
			super.text = value;
			setTextFormat(_format);
		}
	}
}
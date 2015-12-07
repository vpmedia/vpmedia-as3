package starlingx.display
{
import starling.display.*;
	import starlingx.display.Graphics;
	
	public class Shape extends DisplayObjectContainer
	{
		private var _graphics :Graphics;
		
		public function Shape()
		{
			_graphics = new Graphics(this);
		}
		
		public function get graphics():Graphics
		{
			return _graphics;
		}
		
	/*	override public function dispose() : void
		{
			if ( _graphics != null )
			{
				_graphics.dispose();
				_graphics = null;
			}
			super.dispose();
		} */
	}
}
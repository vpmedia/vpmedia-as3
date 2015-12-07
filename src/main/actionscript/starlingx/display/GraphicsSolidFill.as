package starlingx.display
{
import starling.display.*;
	import starlingx.display.IGraphicsData;
	import starlingx.display.materials.IMaterial;
	import flash.geom.Matrix;
	
	
	public class GraphicsSolidFill implements IGraphicsData 
	{
		protected var mColor:uint;
		protected var mAlpha:Number;
		
		public function GraphicsSolidFill(color:uint, alpha:Number ) 
		{
			mColor = color;
			mAlpha = alpha;
		}
		
		public function get color() : uint
		{
			return mColor;
		}
		
		public function get alpha() : Number
		{
			return mAlpha;
		}
	}

}
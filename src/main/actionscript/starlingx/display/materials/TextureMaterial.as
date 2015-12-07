package starlingx.display.materials
{
	import starlingx.display.shaders.IShader;
	import starlingx.display.shaders.fragment.TextureFragmentShader;
	import starlingx.display.shaders.fragment.TextureVertexColorFragmentShader;
	import starlingx.display.shaders.fragment.VertexColorFragmentShader;
	import starlingx.display.shaders.vertex.StandardVertexShader;
	import starling.textures.Texture;
	
	public class TextureMaterial extends StandardMaterial
	{
		public function TextureMaterial(texture:Texture, color:uint = 0xFFFFFF)
		{
			super(new StandardVertexShader(), new TextureVertexColorFragmentShader());
			textures[0] = texture;
			this.color = color;
		}
	}
}
package hu.vpmedia.starlingx {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageQuality;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import starling.textures.Texture;

public class TestBitmapData extends BitmapData {
    public function TestBitmapData(width:int, height:int, fillColor:uint, id:uint) {
        super(width, height, false, fillColor);
        var source:Sprite = new Sprite();
        source.graphics.beginFill(fillColor);
        source.graphics.drawRect(0, 0, width, height);
        source.graphics.endFill();
        var label:TextField = new TextField();
        label.width = width;
        label.height = 20;
        label.y = height * 0.5 - 10;
        label.selectable = false;
        var tf:TextFormat = new TextFormat("Arial", 18, 0xFFFFFF, true);
        tf.align = TextFormatAlign.CENTER;
        label.defaultTextFormat = tf
        label.text = id.toString();
        source.addChild(label);
        drawWithQuality(source, null, null, null, null, false, StageQuality.BEST);
    }

    public static function getTexture(width:int, height:int, fillColor:uint, id:uint):Texture {
        return Texture.fromBitmapData(new TestBitmapData(width, height, fillColor, id))
    }
}
}

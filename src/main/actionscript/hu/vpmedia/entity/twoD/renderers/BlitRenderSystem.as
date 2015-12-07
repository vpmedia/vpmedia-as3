/*
 * =BEGIN CLOSED LICENSE
 *
 * Copyright (c) 2013-2014 Andras Csizmadia
 * http://www.vpmedia.eu
 *
 * For information about the licensing and copyright please
 * contact Andras Csizmadia at andras@vpmedia.eu
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * =END CLOSED LICENSE
 */
package hu.vpmedia.entity.twoD.renderers {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Rectangle;

import hu.vpmedia.blitting.BlitGroup;
import hu.vpmedia.entity.commons.AlignTypes;
import hu.vpmedia.entity.core.BaseEntityStepSystem;
import hu.vpmedia.entity.core.BaseEntityWorld;
import hu.vpmedia.entity.twoD.components.MovieEntityComponent;

/**
 * TBD
 */
public class BlitRenderSystem extends BaseEntityStepSystem {

    /**
     * TBD
     */
    private var _canvas:Bitmap;

    /**
     * TBD
     */
    private var _bitmapData:BitmapData;

    /**
     * TBD
     */
    private const LAYER_IDX:String = "layerIndex";

    /**
     * TBD
     */
    private const GROUP_IDX:String = "zIndex";

    /**
     * TBD
     */
    private var _itemList:Array;

    /**
     * TBD
     */
    private var _fillRect:Rectangle;

    /**
     * TBD
     */
    public function BlitRenderSystem(world:BaseEntityWorld) {
        super(world, BaseRenderNode, onStep, onAdded, onRemoved);
        initialize();
    }

    private function onStep(node:BaseRenderNode, timeStep:Number):void {
        //trace(this, "onStep", node);
    }

    private function onAdded(node:BaseRenderNode):void {
        // trace(this, "onAdded", node);
        if (!node.movie.skin && node.movie.skinClass) {
            node.movie.skin = SpriteFactory.create(node.movie.skinClass, _world.loaderInfo);
        }
        var skin:BlitGroup = BlitGroup(node.movie.skin);
        skin.setCanvas(_canvas.bitmapData);
        // set member index
        node.movie.zIndex = _itemList.length;
        _itemList.push(node);
        // update virtual layers
        _itemList.sort(sortOnLayerIndex);
    }

    private function onRemoved(node:BaseRenderNode):void {
        // trace(this, "onRemoved", node);
        _itemList.splice(_itemList.indexOf(node), 1);
    }

    protected function initialize():void {
        _fillRect = new Rectangle(0, 0, _world.camera.width, _world.camera.height);
        _itemList = [];
        _bitmapData = new BitmapData(_world.camera.width, _world.camera.height, true, _world.backgroundColor);
        _canvas = new Bitmap(_bitmapData);
        _world.context.addChild(_canvas);
    }

    override public function dispose():void {
        if (_world.context.contains(_canvas)) {
            _world.context.removeChild(_canvas);
        }
        _canvas = null;
        try {
            _bitmapData.dispose();
        }
        catch (error:Error) {
        }
        _bitmapData = null;
        super.dispose();
    }

    // HELPERS
    override public function step(timeDelta:Number):void {
        super.step(timeDelta);
        _bitmapData.lock();
        _bitmapData.fillRect(_fillRect, _world.backgroundColor);
        var n:Number = _itemList.length;
        var i:int;
        for (i = 0; i < n; i++) {
            var node:BaseRenderNode = _itemList[i];
            if (!node.movie.visible) {
                return;
            }
            var skin:BlitGroup = BlitGroup(node.movie.skin);
            if (!skin) {
                return;
            }
            var nX:Number = (node.display.x + node.movie.offsetX + _world.camera.x) * node.movie.parallaxFactorX;
            var nY:Number = (node.display.y + node.movie.offsetY + _world.camera.y) * node.movie.parallaxFactorY;
            if (node.movie.registration == AlignTypes.MIDDLE) {
                var r:Rectangle = skin.currentSequence.getFrameBlitArea(skin.currentSequence.currentFrame).frame;
                nX -= r.width * 0.5;
                nY -= r.height * 0.5;
            }
            skin.currentSequence.x = nX;
            skin.currentSequence.y = nY;
            skin.play(node.movie.animation);
            skin.step(timeDelta);
        }
        _bitmapData.unlock();
    }

    /**
     * TBD
     */
    private function sortOnLayerIndex(a:BaseRenderNode, b:BaseRenderNode):Number {
        var aLayer:MovieEntityComponent = a.movie;
        var bLayer:MovieEntityComponent = b.movie;
        if (aLayer.layerIndex > aLayer.layerIndex) {
            return 1;
        }
        else if (aLayer.layerIndex < aLayer.layerIndex) {
            return -1;
        }
        else {
            return 0;
        }
    }
}
}

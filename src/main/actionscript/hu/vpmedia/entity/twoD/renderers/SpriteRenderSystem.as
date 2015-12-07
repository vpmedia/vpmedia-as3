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
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;

import hu.vpmedia.entity.commons.AlignTypes;
import hu.vpmedia.entity.core.BaseEntityStepSystem;
import hu.vpmedia.entity.core.BaseEntityWorld;
import hu.vpmedia.framework.IBaseSteppable;
import hu.vpmedia.utils.MovieClipUtil;

/**
 * TBD
 */
public class SpriteRenderSystem extends BaseEntityStepSystem {

    /**
     * TBD
     */
    private static const DEG_TO_RAD:Number = Math.PI / 180; //0.017453293;

    /**
     * TBD
     */
    private var _canvas:Sprite;

    /**
     * TBD
     */
    private var _layers:Vector.<SpriteLayer>;

    /**
     * TBD
     */
    public function SpriteRenderSystem(world:BaseEntityWorld) {
        super(world, BaseRenderNode, onStep, onAdded, onRemoved);
        initialize();
    }

    /**
     * TBD
     */
    private function initialize():void {
        _layers = new Vector.<SpriteLayer>;
        _canvas = new Sprite();
        _world.context.addChild(_canvas);
    }

    /**
     * TBD
     */
    override public function dispose():void {
        if (_world.context.contains(_canvas)) {
            _world.context.removeChild(_canvas);
        }
        _layers.length = 0;
        _canvas = null;
        super.dispose();
    }

    // Loop

    /**
     * TBD
     */
    override public function step(timeDelta:Number):void {
        // update canvas by camera target
        if (_world.camera.target) {
            _canvas.x = _world.camera.x;
            _canvas.y = _world.camera.y;
        }
        // update layers
        var n:int = _layers.length;
        var layer:SpriteLayer;
        for (var i:int = 0; i < n; i++) {
            layer = _layers[i];
            layer.x = -_canvas.x * (1 - layer.parallaxFactorX);
            layer.y = -_canvas.y * (1 - layer.parallaxFactorY);
        }
        super.step(timeDelta);
    }

    private function onAdded(node:BaseRenderNode):void {
        //trace(this, "onAdded", node);
        if (!node.movie.skin && node.movie.skinClass) {
            node.movie.skin = SpriteFactory.create(node.movie.skinClass, _world.loaderInfo);
        }
        // get skin instance
        var skin:DisplayObject = DisplayObject(node.movie.skin);
        // add skin instance to layer
        if (skin) {
            // create unavailable layers
            while (node.movie.layerIndex >= _canvas.numChildren) {
                var id:int = _layers.length;
                var layer:SpriteLayer = new SpriteLayer(id);
                _canvas.addChild(layer);
                _layers.push(layer);
                layer.parallaxFactorX = node.movie.parallaxFactorX;
                layer.parallaxFactorY = node.movie.parallaxFactorY;
                //trace("\tLayer", layer.id, "created");
            }
            // assign display z-index
            node.movie.zIndex = _layers[node.movie.layerIndex].numChildren;
            // add to display list
            _layers[node.movie.layerIndex].addChild(skin);
            // first update outside the loop
            //onStep(child, 0);
        }
    }

    private function onRemoved(node:BaseRenderNode):void {
        // trace(this, "onRemoved", node);
        if (!node.movie.skin) {
            return;
        }
        if (node.movie.skin.parent && node.movie.skin.parent.contains(node.movie.skin)) {
            node.movie.skin.parent.removeChild(node.movie.skin);
        }
    }

    private function onStep(node:BaseRenderNode, timeDelta:Number):void {
        //trace(this, entity, timeDelta);
        if (!node.movie.skin) {
            return;
        }
        // validate by visibility
        node.movie.skin.visible = node.movie.visible;
        if (!node.movie.visible) {
            return;
        }
        // update rotation (first we reset to get proper center point)
        // TODO: refactor to get this just once for all at addition level
        node.movie.skin.rotation = 0;
        //skin.rotation=child.rotation;
        //trace(skin.width/2, skin.height/2,child.rotation)
        // update position and inverted scale
        var nX:Number = node.display.x + node.movie.offsetX;
        var nY:Number = node.display.y + node.movie.offsetY;
        if (node.movie.inverted) {
            nX += node.movie.skin.width;
            node.movie.skin.scaleX = -node.movie.skin.scaleX;
        }
        if (node.movie.registration == AlignTypes.MIDDLE) {
            nX -= node.movie.skin.width * 0.5;
            nY -= node.movie.skin.height * 0.5;
        }
        node.movie.skin.x = nX;
        node.movie.skin.y = nY;
        if (node.movie.registration == AlignTypes.MIDDLE) {
            var matrix:Matrix = node.movie.skin.transform.matrix.clone();
            rotateAroundInternalPoint(matrix, node.movie.skin.width / 2, node.movie.skin.height / 2, node.display.rotation);
            node.movie.skin.transform.matrix = matrix;
        }
        else {
            node.movie.skin.rotation = node.display.rotation;
        }
        // update movie clip label state
        if (node.movie.skin is MovieClip) {
            var t:MovieClip = MovieClip(node.movie.skin);
            if (node.movie.animation && MovieClipUtil.isValidFrameLabel(t, node.movie.animation)) {
                t.gotoAndStop(node.movie.animation);
            }
        }
        if (node.movie.skin is IBaseSteppable) {
            IBaseSteppable(node.movie.skin).step(timeDelta);
        }
    }

    private function rotateAroundInternalPoint(m:Matrix, x:Number, y:Number, angleDegrees:Number):void {
        var point:Point = new Point(x, y);
        point = m.transformPoint(point);
        m.tx -= point.x;
        m.ty -= point.y;
        m.rotate(angleDegrees * DEG_TO_RAD);
        m.tx += point.x;
        m.ty += point.y;
    }
}
}

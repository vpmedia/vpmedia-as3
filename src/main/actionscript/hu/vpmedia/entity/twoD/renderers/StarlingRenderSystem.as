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
import hu.vpmedia.entity.commons.AlignTypes;
import hu.vpmedia.entity.core.BaseEntityStepSystem;
import hu.vpmedia.entity.core.BaseEntityWorld;
import hu.vpmedia.starlingx.MovieClipGroup;
import hu.vpmedia.utils.MathUtil;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.MovieClip;
import starling.display.Sprite;

/**
 * @inheritDoc
 */
public final class StarlingRenderSystem extends BaseEntityStepSystem {
    /**
     * @private
     */
    private var _system:Starling;

    /**
     * @private
     */
    private var _canvas:Sprite;

    /**
     * @private
     */
    private var _layers:Vector.<StarlingLayer>;

    /**
     * Constructor
     */
    public function StarlingRenderSystem(world:BaseEntityWorld, canvas:Sprite) {
        super(world, BaseRenderNode, onStep, onAdded, onRemoved);
        _canvas = canvas;
        initialize();
    }

    private function initialize():void {
        _layers = new Vector.<StarlingLayer>;
        _system = Starling.current;
        if (!_canvas) {
            _canvas = new Sprite();
            _system.stage.addChild(_canvas);
        }
    }

    override public function dispose():void {
        _system.dispose();
        _layers.length = 0;
        _system = null;
        super.dispose();
    }

    override public function step(timeDelta:Number):void {
        if (_world.camera.target) {
            _canvas.x = _world.camera.x;
            _canvas.y = _world.camera.y;
        }
        // update layers
        var n:int = _layers.length;
        var layer:StarlingLayer;
        for (var i:int = 0; i < n; i++) {
            layer = _layers[i];
            layer.x = -_canvas.x * (1 - layer.parallaxFactorX);
            layer.y = -_canvas.y * (1 - layer.parallaxFactorY);
        }
        super.step(timeDelta);
    }

    private function onStep(node:BaseRenderNode, timeStep:Number):void {
        //trace(this, "onStep", node);
        var skin:DisplayObject = DisplayObject(node.movie.skin);
        if (!skin) {
            return;
        }
        // validate by visibility
        skin.visible = node.movie.visible;
        if (!node.movie.visible) {
            return;
        }
        skin.rotation = 0;
        // update position and inverted scale
        var nX:Number = node.display.x + node.movie.offsetX;
        var nY:Number = node.display.y + node.movie.offsetY;
        if (node.movie.inverted) {
            nX += skin.width;
            skin.scaleX = -1;
        }
        else {
            skin.scaleX = 1;
        }
        if (node.movie.registration == AlignTypes.MIDDLE) {
            nX -= skin.width * 0.5;
            nY -= skin.height * 0.5;
        }
        skin.x = nX;
        skin.y = nY;
        //trace(node.display.rotation);
        skin.rotation = node.display.rotation * MathUtil.DEG_TO_RAD;
        // update animation state
        if (node.movie.animation) {
            if (skin is MovieClip) {
                // _textureAtlas.getTextures(node.animation)
                MovieClip(skin).currentFrame = int(node.movie.animation);
            } else if (skin is MovieClipGroup) {
                MovieClipGroup(skin).playSequence(node.movie.animation, 24, true);
            }
        }
    }

    private function onAdded(node:BaseRenderNode):void {
        //trace(this, "onAdded", node);
        if (!node.movie.skin && node.movie.skinClass) {
            node.movie.skin = StarlingFactory.create(node.movie.skinClass, _world.loaderInfo);
        }
        var skin:DisplayObject = DisplayObject(node.movie.skin);
        // add skin instance to layer
        if (skin) {
            // check layer exists
            // create unavailable layers
            while (node.movie.layerIndex >= _canvas.numChildren) {
                var id:int = _layers.length;
                var layer:StarlingLayer = new StarlingLayer(id);
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
            // add to starling juggler list
            if (node.movie.registration == AlignTypes.MIDDLE) {
                skin.pivotX = skin.width * 0.5;
                skin.pivotY = skin.height * 0.5;
            }
            if (skin is MovieClip) {
                Starling.juggler.add(MovieClip(skin));
            }
            // first update outside the loop
            //drawChild(child);
        }
    }

    private function onRemoved(node:BaseRenderNode):void {
        //trace(this, "onRemoved", node);
        var skin:DisplayObject = DisplayObject(node.movie.skin);
        if (!skin) {
            return;
        }
        if (skin is MovieClip) {
            Starling.juggler.remove(MovieClip(skin));
        }
        skin.removeFromParent(true);
    }

}
}

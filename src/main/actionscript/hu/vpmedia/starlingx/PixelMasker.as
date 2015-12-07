/*
 * =BEGIN CLOSED LICENSE
 *
 * Copyright (c) 2014 Andras Csizmadia
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
package hu.vpmedia.starlingx {
import flash.display3D.Context3DBlendFactor;
import flash.geom.Matrix;

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.BlendMode;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Image;
import starling.events.Event;
import starling.textures.RenderTexture;

/**
 * @inheritDoc
 */
public final class PixelMasker extends DisplayObjectContainer {
    /**
     * @private
     */
    private var _mask:DisplayObject;
    /**
     * @private
     */
    private var _renderTexture:RenderTexture;
    /**
     * @private
     */
    private var _maskRenderTexture:RenderTexture;
    /**
     * @private
     */
    private var _image:Image;
    /**
     * @private
     */
    private var _maskImage:Image;
    /**
     * @private
     */
    private var _superRenderFlag:Boolean;
    /**
     * @private
     */
    private var _inverted:Boolean;
    /**
     * @private
     */
    private var _scaleFactor:Number;
    /**
     * @private
     */
    private var _isAnimated:Boolean;
    /**
     * @private
     */
    private var _maskRendered:Boolean;
    /**
     * @private
     */
    private static const MASK_MODE_NORMAL:String = "mask";
    /**
     * @private
     */
    private static const MASK_MODE_INVERTED:String = "maskinverted";
    /**
     * @private
     */
    private static var _a:Number;
    /**
     * @private
     */
    private static var _b:Number;
    /**
     * @private
     */
    private static var _c:Number;
    /**
     * @private
     */
    private static var _d:Number;
    /**
     * @private
     */
    private static var _tx:Number;
    /**
     * @private
     */
    private static var _ty:Number;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * @inheritDoc
     */
    public function PixelMasker(scaleFactor:Number = -1, isAnimated:Boolean = false) {
        super();
        _isAnimated = isAnimated;
        _scaleFactor = scaleFactor;
        initialize();
    }

    /**
     * @private
     */
    private function initialize():void {
        BlendMode.register(MASK_MODE_NORMAL, Context3DBlendFactor.ZERO, Context3DBlendFactor.SOURCE_ALPHA);
        BlendMode.register(MASK_MODE_INVERTED, Context3DBlendFactor.ZERO, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
        Starling.current.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
        touchable = false;
    }

    //----------------------------------
    //  Inherited Methods
    //----------------------------------

    /**
     * @inheritDoc
     */
    override public function dispose():void {
        clearRenderTextures();
        Starling.current.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
        super.dispose();
    }

    /**
     * @inheritDoc
     */
    public override function render(support:RenderSupport, parentAlpha:Number):void {
        if (_isAnimated || (!_isAnimated && !_maskRendered)) {
            if (_superRenderFlag || !_mask) {
                super.render(support, parentAlpha);
            } else {
                if (_mask) {
                    _maskRenderTexture.draw(_mask);
                    _renderTexture.drawBundled(drawRenderTextures);
                    _image.render(support, parentAlpha);
                    _maskRendered = true;
                }
            }
        } else {
            _image.render(support, parentAlpha);
        }
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Forces display object to redraw
     */
    public function invalidate():void {
        _maskRendered = false;
    }

    //----------------------------------
    //  Getters / Setters
    //----------------------------------

    /**
     * TBD
     */
    public function get isAnimated():Boolean {
        return _isAnimated;
    }

    /**
     * TBD
     */
    public function set isAnimated(value:Boolean):void {
        _isAnimated = value;
    }

    /**
     * TBD
     */
    public function get inverted():Boolean {
        return _inverted;
    }

    /**
     * TBD
     */
    public function set inverted(value:Boolean):void {
        _inverted = value;
        refreshRenderTextures(null);
    }

    /**
     * TBD
     */
    public function set masker(mask:DisplayObject):void {
        // clean up existing mask if there is one
        if (_mask) {
            _mask = null;
        }
        if (mask) {
            _mask = mask;
            if (!_mask.width || !_mask.height) {
                throw new Error("Mask must have dimensions. Current dimensions are " + _mask.width + "x" + _mask.height + ".");
            }
            refreshRenderTextures(null);
        } else {
            clearRenderTextures();
        }
    }

    //----------------------------------
    //  Private Methods
    //----------------------------------

    /**
     * @private
     */
    private function onContextCreated(event:Event):void {
        refreshRenderTextures();
    }

    /**
     * @private
     */
    private function clearRenderTextures():void {
        if (_maskRenderTexture) {
            _maskRenderTexture.dispose();
        }
        if (_renderTexture) {
            _renderTexture.dispose();
        }
        if (_image) {
            _image.dispose();
        }
        if (_maskImage) {
            _maskImage.dispose();
        }
    }

    /**
     * @private
     */
    private function refreshRenderTextures(event:Event = null):void {
        if (_mask) {
            clearRenderTextures();
            _maskRenderTexture = new RenderTexture(_mask.width, _mask.height, false, _scaleFactor);
            _renderTexture = new RenderTexture(_mask.width, _mask.height, false, _scaleFactor);
            // create image with the new render texture
            _image = new Image(_renderTexture);
            // create image to blit the mask onto
            _maskImage = new Image(_maskRenderTexture);
            // set the blending mode to MASK (ZERO, SRC_ALPHA)
            if (_inverted) {
                _maskImage.blendMode = MASK_MODE_INVERTED;
            } else {
                _maskImage.blendMode = MASK_MODE_NORMAL;
            }
        }
        _maskRendered = false;
    }

    /**
     * @private
     */
    private function drawRenderTextures(object:DisplayObject = null, matrix:Matrix = null, alpha:Number = 1.0):void {
        _a = this.transformationMatrix.a;
        _b = this.transformationMatrix.b;
        _c = this.transformationMatrix.c;
        _d = this.transformationMatrix.d;

        _tx = this.transformationMatrix.tx;
        _ty = this.transformationMatrix.ty;

        this.transformationMatrix.a = 1;
        this.transformationMatrix.b = 0;
        this.transformationMatrix.c = 0;
        this.transformationMatrix.d = 1;

        this.transformationMatrix.tx = 0;
        this.transformationMatrix.ty = 0;

        _superRenderFlag = true;
        _renderTexture.draw(this);
        _superRenderFlag = false;

        this.transformationMatrix.a = _a;
        this.transformationMatrix.b = _b;
        this.transformationMatrix.c = _c;
        this.transformationMatrix.d = _d;

        this.transformationMatrix.tx = _tx;
        this.transformationMatrix.ty = _ty;

        _renderTexture.draw(_maskImage);
    }
}
}

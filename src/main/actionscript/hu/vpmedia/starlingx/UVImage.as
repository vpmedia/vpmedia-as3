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
import flash.geom.Rectangle;

import starling.display.Image;
import starling.textures.Texture;

/**
 * TBD
 */
public final class UVImage extends Image {

    /**
     * @private
     */
    private var _scrollX:Number = 0;

    /**
     * @private
     */
    private var _scrollY:Number = 0;

    /**
     * @private
     */
    private var _ratioX:Number = 0;

    /**
     * @private
     */
    private var _ratioY:Number = 0;

    /**
     * @private
     */
    private var _clipMask:Rectangle;

    /**
     * TBD
     */
    public function UVImage(texture:Texture) {
        super(texture);
        initialize();
    }

    /**
     * @private
     */
    private function initialize():void {
        touchable = false;
        _ratioX = 1 / texture.width;
        _ratioY = 1 / texture.height;
        _clipMask = new Rectangle(0, 0, width, height);
        updateMask();
    }

    /**
     * @inheritDoc
     */
    public override function dispose():void {
        super.dispose();

        if (_clipMask) {
            _clipMask = null;
        }
    }

    /**
     * @private
     */
    private function updateMask():void {
        mVertexData.setPosition(0, _clipMask.left, _clipMask.top);
        mVertexData.setPosition(1, _clipMask.right, _clipMask.top);
        mVertexData.setPosition(2, _clipMask.left, _clipMask.bottom);
        mVertexData.setPosition(3, _clipMask.right, _clipMask.bottom);
    }

    /**
     * @private
     */
    private function invalidate():void {
        const scrollLeft:Number = (_scrollX + _clipMask.left) * _ratioX;
        const scrollTop:Number = (_scrollY + _clipMask.top) * _ratioY;
        const scrollRight:Number = (_scrollX + _clipMask.right) * _ratioX;
        const scrollBottom:Number = (_scrollY + _clipMask.bottom) * _ratioY;
        mVertexData.setTexCoords(0, scrollLeft, scrollTop);
        mVertexData.setTexCoords(1, scrollRight, scrollTop);
        mVertexData.setTexCoords(2, scrollLeft, scrollBottom);
        mVertexData.setTexCoords(3, scrollRight, scrollBottom);
        onVertexDataChanged();
    }

    /**
     * TBD
     */
    public function get scrollX():int {
        return _scrollX;
    }

    /**
     * @private
     */
    public function set scrollX(value:int):void {
        _scrollX = value % texture.width;
        invalidate();
    }

    /**
     * TBD
     */
    public function get scrollY():int {
        return _scrollY;
    }

    /**
     * @private
     */
    public function set scrollY(value:int):void {
        _scrollY = value % texture.height;
        invalidate();
    }

    /**
     * TBD
     */
    public function get clipMaskLeft():Number {
        return _clipMask.left;
    }

    /**
     * @private
     */
    public function set clipMaskLeft(n:Number):void {
        _clipMask.left = n;
        updateMask();
        invalidate();
    }

    /**
     * TBD
     */
    public function get clipMaskTop():Number {
        return _clipMask.top;
    }

    /**
     * @private
     */
    public function set clipMaskTop(n:Number):void {
        _clipMask.top = n;
        updateMask();
        invalidate();
    }

    /**
     * TBD
     */
    public function get clipMaskRight():Number {
        return _clipMask.right;
    }

    /**
     * @private
     */
    public function set clipMaskRight(n:Number):void {
        _clipMask.right = n;
        updateMask();
        invalidate();
    }

    /**
     * TBD
     */
    public function get clipMaskBottom():Number {
        return _clipMask.bottom;
    }

    /**
     * @private
     */
    public function set clipMaskBottom(n:Number):void {
        _clipMask.bottom = n;
        updateMask();
        invalidate();
    }
}
}
/*
 * =BEGIN CLOSED LICENSE
 *
 *  Copyright(c) 2014 Andras Csizmadia.
 *  http://www.vpmedia.eu
 *
 *  For information about the licensing and copyright please
 *  contact Andras Csizmadia at andras@vpmedia.eu.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 *
 * =END CLOSED LICENSE
 */

package hu.vpmedia.starlingx {
import flash.geom.Rectangle;

import starling.display.BlendMode;

import starling.display.Sprite;
import starling.textures.Texture;

/**
 * TBD
 */
public final class InfiniteImage extends Sprite {

    /**
     * Scroll x per tick
     */
    public var scrollX:Number = 0;

    /**
     * Scroll x per tick
     */
    public var scrollY:Number = 0;

    /**
     * Vector x of revolutions since started
     */
    public var cyclesX:int;

    /**
     * Vector y of revolutions since started
     */
    public var cyclesY:int;

    /**
     * @private
     */
    public var nextRow:Vector.<InfiniteImageTile>;

    /**
     * @private
     */
    public var nextColumn:Vector.<InfiniteImageTile>;

    /**
     * @private
     */
    private var _tileWidth:Number;

    /**
     * @private
     */
    private var _tileHeight:Number;

    /**
     * @private
     */
    private var _numCols:uint;

    /**
     * @private
     */
    private var _numRows:uint;

    /**
     * @private
     */
    private var _numTiles:int;

    /**
     * @private
     */
    private var _tilesOffsetX:Number = 0;

    /**
     * @private
     */
    private var _tilesOffsetY:Number = 0;

    /**
     * @private
     */
    private var _cellOffsetX:int = 0;

    /**
     * @private
     */
    private var _cellOffsetY:int = 0;

    /**
     * @private
     */
    private var _cellPadX:int = 0;

    /**
     * @private
     */
    private var _cellPadY:int = 0;

    /**
     * @private
     */
    private var _textureWidth:uint = 0;

    /**
     * @private
     */
    private var _textureHeight:uint = 0;

    /**
     * @private
     */
    private static const DEG_TO_RAD:Number = 180 / Math.PI;
    /**
     * @private
     */
    private static const RAD_TO_DEG:Number = Math.PI / 180;

    /**
     * Constructor
     *
     * @param textures The 2D list of tile textures
     */
    public function InfiniteImage(textures:Vector.<Vector.<Texture>>, numCols:int = 0, numRows:int = 0, cellOffsetX:int = 0, cellOffsetY:int = 0, cellPadX:int = 0, cellPadY:int = 0, textureWidth:uint = 0, textureHeight:uint = 0) {
        _numCols = numCols;
        _numRows = numRows;
        _cellOffsetX = cellOffsetX;
        _cellOffsetY = cellOffsetY;
        _cellPadX = cellPadX;
        _cellPadY = cellPadY;
        _textureWidth = textureWidth;
        _textureHeight = textureHeight;
        super();
        initialize(textures);
    }

    /**
     * @private
     */
    private function initialize(textures:Vector.<Vector.<Texture>>):void {
        if(!textures.length || !textures[0].length) {
            return;
        }
        //trace(this, "initialize", arguments);
        //touchable = false;
        //blendMode = BlendMode.NONE;
        if(!_textureWidth) {
            _textureWidth = textures[0][0].width;
        }
        if(!_textureHeight) {
            _textureHeight = textures[0][0].height;
        }
        _tileWidth = _textureWidth + _cellPadX;
        _tileHeight = _textureHeight + _cellPadY;
        if (!_numCols)
            _numCols = textures.length;
        if (!_numRows)
            _numRows = textures[0].length;
        _numTiles = _numCols * _numRows;
        nextColumn = new Vector.<InfiniteImageTile>(_numRows);
        nextRow = new Vector.<InfiniteImageTile>(_numCols);
        _cellOffsetX = Math.max(Math.min(0, _cellOffsetX), -_numRows);
        _cellOffsetY = Math.max(Math.min(0, _cellOffsetY), -_numCols);
        for (var i:uint = 0; i < _numCols; i++) {
            for (var j:uint = 0; j < _numRows; j++) {
                const texture:Texture = textures[i][j];
                const image:InfiniteImageTile = new InfiniteImageTile(texture);
                addChild(image);
                image.width = _textureWidth;
                image.height = _textureHeight;
                image.x = (_cellOffsetX * _tileWidth) + (i * _tileWidth);
                image.y = (_cellOffsetY * _tileHeight) + (j * _tileHeight);
                image.col = i;
                image.row = j;
                image.id = i + (j * _numRows);
                image.name = "img_" + i + "_" + j;
            }
        }
    }

    /**
     * TBD
     */
    public function setTileClipRect(nX:Number = 1, nY:Number = 1):void {
        clipRect = new Rectangle(0, 0, _tileWidth * nX, _tileHeight * nY);
    }

    /**
     * TBD
     */
    public function setScroll(sX:Number, sY:Number):void {
        scrollX = sX;
        scrollY = sY;
    }

    /**
     * TBD
     */
    public function moveTo(nX:Number, nY:Number):void {
        const lastScrollX:Number = scrollX;
        const lastScrollY:Number = scrollY;
        scrollX = nX;
        scrollY = nY;
        step(1);
        scrollX = lastScrollX;
        scrollY = lastScrollY;
    }

    /**
     * Will update the textures and reset the tile image
     */
    public function setTextures(textures:Vector.<Vector.<Texture>>):void {
        var index:uint = 0;
        for (var i:uint = 0; i < _numCols; i++) {
            for (var j:uint = 0; j < _numRows; j++) {
                const texture:Texture = textures[i][j];
                const image:InfiniteImageTile = InfiniteImageTile(getChildAt(index++));
                if(image.col != i || image.row != j) {
                    trace("Wrong image: " + image);
                }
                image.texture = texture;
                image.x = (_cellOffsetX * _tileWidth) + (i * _tileWidth);
                image.y = (_cellOffsetY * _tileHeight) + (j * _tileHeight);
            }
        }
        scrollX = scrollY = 0;
        cyclesX = cyclesY = 0;
        _tilesOffsetX = _tilesOffsetY = 0;
    }

    /**
     * TBD
     */
    public function set scrollAngle(angle:Number):void {
        scrollX = Math.cos(angle);
        scrollY = Math.sin(angle);
    }

    /**
     * TBD
     */
    public function get scrollAngle():Number {
        return Math.atan2(scrollY, scrollX);
    }

    /**
     * TBD
     */
    public function set scrollRotation(rotation:Number):void {
        scrollAngle = rotation * RAD_TO_DEG;
    }

    /**
     * TBD
     */
    public function get scrollRotation():Number {
        return scrollAngle * DEG_TO_RAD;
    }

    /**
     * TBD
     */
    public function get tileWidth():Number {
        return _tileWidth;
    }

    /**
     * TBD
     */
    public function get tileHeight():Number {
        return _tileHeight;
    }

    /**
     * TBD
     */
    /*override public function get width():Number {
        return _tileWidth * _numCols;
    }*/

    /**
     * TBD
     */
    /*override public function get height():Number {
        return _tileHeight * _numRows;
    }*/

    /**
     * TBD
     */
    public function set tilesOffsetX(value:Number):void {
        //trace("tilesOffsetY: " + value);
        const lastScrollX:Number = scrollX;
        scrollX = value - _tilesOffsetX;
        step(1);
        scrollX = lastScrollX;
        _tilesOffsetX = value;
    }

    /**
     * TBD
     */
    public function get tilesOffsetX():Number {
        return _tilesOffsetX;
    }

    /**
     * TBD
     */
    public function set tilesOffsetY(value:Number):void {
        //trace("tilesOffsetY: " + value);
        const lastScrollY:Number = scrollY;
        scrollY = value - tilesOffsetY;
        step(1);
        scrollY = lastScrollY;
        _tilesOffsetY = value;
    }

    /**
     * TBD
     */
    public function get tilesOffsetY():Number {
        return _tilesOffsetY;
    }

    /**
     * TBD
     */
    public function step(timeDelta:Number = 1):void {
        var isHorizontalChanged:Boolean;
        var isVerticalChanged:Boolean;
        var image:InfiniteImageTile;
        for (var i:uint = 0; i < _numTiles; i++) {
            image = InfiniteImageTile(getChildAt(i));
            // horizontal scrolling
            if (_numCols > 1 && scrollX != 0) {
                image.x += scrollX * timeDelta;
                if (scrollX < 0 && image.x <= -_tileWidth) {
                    //trace("X+", image);
                    image.x += _tileWidth * _numCols;
                    isHorizontalChanged = true;
                    //trace("X+", image);
                    nextColumn[image.row] = image;
                } else if (scrollX > 0 && image.x >= (_tileWidth * (_numCols - 1))) {
                    //trace("X-", image);
                    image.x -= _tileWidth * _numCols;
                    isHorizontalChanged = true;
                    //trace("X-", image);
                    nextColumn[image.row] = image;
                }
            }
            // vertical scrolling
            if (_numRows > 1 && scrollY != 0) {
                image.y += scrollY * timeDelta;
                if (scrollY < 0 && image.y <= -_tileHeight) {
                    //trace("Y-", image);
                    image.y += _tileHeight * _numRows;
                    isVerticalChanged = true;
                    //trace("Y-", image);
                    nextRow[image.col] = image;
                } else if (scrollY > 0 && image.y >= (_tileHeight * (_numRows - 1))) {
                    //trace("Y+", image);
                    image.y -= _tileHeight * _numRows;
                    isVerticalChanged = true;
                    //trace("Y+", image);
                    nextRow[image.col] = image;
                }
            }
        }
        if (isHorizontalChanged) {
            cyclesX += scrollX > 0 ? -1 : 1;
        }
        if (isVerticalChanged) {
            cyclesY += scrollY < 0 ? -1 : 1;
        }
        image = null;
    }

    /**
     * TBD
     */
    public function toString():String {
        return "[InfiniteImage"
                + " scrollX=" + scrollX
                + " scrollY=" + scrollY
                + " cyclesX=" + cyclesX
                + " cyclesY=" + cyclesY
                + " numCols=" + _numCols
                + " numRows=" + _numRows
                + " numTiles=" + _numTiles
                + "]";
    }
}
}
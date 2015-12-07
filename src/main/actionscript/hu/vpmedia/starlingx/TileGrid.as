/*
 * =BEGIN CLOSED LICENSE
 *
 *  Copyright (c) 2013 Andras Csizmadia
 *  http://www.vpmedia.eu
 *
 *  For information about the licensing and copyright please
 *  contact us at info@vpmedia.eu
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
import flash.geom.Point;
import flash.geom.Rectangle;

import starling.display.DisplayObject;
import starling.display.Sprite;

public class TileGrid extends Sprite {
    /**
     * @private
     */
    private var numRows:int;

    /**
     * @private
     */
    private var numCols:int;

    /**
     * @private
     */
    private var tileWidth:int;

    /**
     * @private
     */
    private var tileHeight:int;

    /**
     * Constructor
     */
    public function TileGrid(numCols:int, numRows:int, tileWidth:int, tileHeight:int) {
        this.numCols = numCols;
        this.numRows = numRows;
        this.tileWidth = tileWidth;
        this.tileHeight = tileHeight;
        clipRect = new Rectangle(0, 0, tileWidth * numCols, tileHeight * numRows);
        super();
    }

    /**
     * Resorts container by coordinates.
     */
    public function resortContainer():void {
        //trace(this, "resortContainer");
        sortChildren(sortByGrid);
    }

    /**
     * Returns cell display object by coordinates.
     */
    public function getCell(cx:int, cy:int):DisplayObject {
        const index:int = getCellIndex(cx, cy);
        //trace(this, "getCell", arguments, " => ", index);
        return getChildAt(index);
    }


    /**
     * Returns cell index by coordinates.
     */
    public function getCellIndex(cx:int, cy:int):int {
        return cx + (cy * numCols);
    }

    /**
     * Switches two cells by Coordinates.
     */
    public function switchCellsAt(x1:int, y1:int, x2:int, y2:int):void {
        if (x1 != x2 || y1 != y2) {
            const a:DisplayObject = getCell(x1, y1);
            const b:DisplayObject = getCell(x2, y2);
            switchCells(a, b);
        }
    }

    /**
     * Switches two cells by Points.
     */
    public function switchCellsAtPoint(p1:Point, p2:Point):void {
        if (!p1.equals(p2)) {
            switchCellsAt(p1.x, p1.y, p2.x, p2.y);
        }
    }

    /**
     * Switches two cells by Points.
     */
    public function switchCells(a:DisplayObject, b:DisplayObject):void {
        const cx:int = a.x;
        const cy:int = a.y;
        a.x = b.x;
        a.y = b.y;
        b.x = cx;
        b.y = cy;
        swapChildren(a, b);
    }

    //----------------------------------
    //  Debug Methods
    //----------------------------------

    /**
     * Dumps the grid as string and traces it.
     */
    public function dumpGrid():void {
        const n:uint = numChildren;
        var result:String = "";
        var col:int;
        for (var i:uint = 0; i < n; i++) {
            var c:DisplayObject = getChildAt(i);
            const s:String = i + ": " + c.x / tileWidth + "," + c.y / tileHeight;
            if (i < 10)
                result += " ";
            result += s + " | ";
            col++;
            if (col == numCols) {
                result += "\n";
                col = 0;
            }
        }
        trace(result);
    }

    //----------------------------------
    //  Helper Methods
    //----------------------------------

    /**
     * TBD
     */
    private function sortByGrid(a:DisplayObject, b:DisplayObject):int {
        const cA:int = getCellIndex(a.x / tileWidth, a.y / tileHeight);
        const cB:int = getCellIndex(b.x / tileWidth, b.y / tileHeight);
        if (cA > cB) return 1;
        if (cB < cA) return -1;
        return 0;
    }
}
}

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
package hu.vpmedia.shapes.core {
import flash.display.Graphics;

/**
 * TBD
 */
public interface IBaseGraphicsTexture {

    /**
     * TBD
     */
    function set colorType(value:uint):void;

    /**
     * TBD
     */
    function get colorType():uint;

    /**
     * TBD
     */
    function set width(value:Number):void;

    /**
     * TBD
     */
    function get width():Number;

    /**
     * TBD
     */
    function set height(value:Number):void;

    /**
     * TBD
     */
    function get height():Number;

    /**
     * TBD
     */
    function draw(graphics:Graphics):void;
}
}

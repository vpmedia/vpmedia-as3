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
package hu.vpmedia.shapes {

/**
 * TBD
 */
public final class PixelIconTypes {

    /**
     * TBD
     */
    public static const ARROW_1_UP:Array = ["   *   ", "  ***  ", " ***** ", "*******"];

    /**
     * TBD
     */
    public static const ARROW_1_DOWN:Array = ["*******", " ***** ", "  ***  ", "   *   "];

    /**
     * TBD
     */
    public static const ARROW_2_UP:Array = ["  *  ", " * * ", "*   *"];

    /**
     * TBD
     */
    public static const ARROW_2_DOWN:Array = ["*   *", " * * ", "  *  "];

    /**
     * TBD
     */
    public static const ARROW_2_LEFT:Array = ["  *", " * ", "*  ", " * ", "  *"];

    /**
     * TBD
     */
    public static const ARROW_2_RIGHT:Array = ["*  ", " * ", "  *", " * ", "*  "];

    /**
     * TBD
     */
    public static const ZOOM_PLUS:Array = ["  *  ", "  *  ", "*****", "  *  ", "  *  "];

    /**
     * TBD
     */
    public static const ZOOM_MINUS:Array = ["     ", "     ", "*****", "     ", "     "];

    /**
     * TBD
     */
    public static const ZOOM_DEFAULT:Array = ["   *   ", "  * *  ", " *   * ", "*  *  *", " *   * ", "  * *  ", "   *   "];

    /**
     * TBD
     */
    public static const SCROLL_GRIP:Array = ["*******", "       ", "*******", "       ", "*******", "       ", "*******", "       ", "*******"];

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * TBD
     */
    public function PixelIconTypes() {
        throw new Error("Error! Cannot instantiate 'PixelIconTypes' class.");
    }
}
}

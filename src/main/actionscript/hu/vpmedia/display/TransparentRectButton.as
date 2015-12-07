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
package hu.vpmedia.display {
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.SimpleButton;

public class TransparentRectButton extends SimpleButton {
    public function TransparentRectButton(width:Number, height:Number, ellipse:Number = 0) {
        var hitTestState:Shape = new Shape();
        var g:Graphics = hitTestState.graphics;
        g.beginFill(0x00FF00, 0);
        g.drawRoundRect(0, 0, width, height, ellipse);
        g.endFill();
        this.useHandCursor = false;
        super(null, null, null, hitTestState);
    }
}
}

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
import flash.display.Sprite;
import flash.filters.DropShadowFilter;

/** @private */
public class LinePreloader extends Sprite {
    private var progressHeight:uint;
    private var progressWidth:uint;
    private var progressBarColor:uint;
    private var progressContainer:Sprite = new Sprite();
    private var progressFrame:Sprite = new Sprite();
    private var progressBar:Sprite = new Sprite();

    public function LinePreloader(widthP:uint = 100, heightP:uint = 5, borderSizeP:uint = 1, barColorP:uint = 0x00FF00, borderColorP:uint = 0x666666) {
        progressHeight = heightP;
        progressWidth = widthP;
        progressBarColor = barColorP;
        var dropShadow:DropShadowFilter = new DropShadowFilter(2, 45, 0x000000, .5, 2, 2);
        progressContainer.addChild(progressBar);
        progressContainer.addChild(progressFrame);
        progressFrame.filters = [dropShadow];
        progressFrame.graphics.clear();
        progressFrame.graphics.lineStyle(borderSizeP, borderColorP);
        progressFrame.graphics.drawRoundRect(0, 0, widthP, heightP, borderSizeP * 2, borderSizeP * 2);
        progressFrame.graphics.endFill();
        addChild(progressContainer);
    }

    public function update(percent:uint):void {
        progressBar.graphics.clear();
        progressBar.graphics.beginFill(progressBarColor);
        progressBar.graphics.drawRect(0, 0, (progressWidth * (percent / 100)), progressHeight);
        progressBar.graphics.endFill();
    }
}
}

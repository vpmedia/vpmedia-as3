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
package hu.vpmedia.components.skins {
import hu.vpmedia.components.core.BaseSkin;
import hu.vpmedia.components.core.BaseSkinConfig;

/**
 * @inheritDoc
 */
public class ImageSkin extends BaseSkin {
    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * Constructor
     */
    public function ImageSkin(config:BaseSkinConfig = null) {
        super(config);
    }

    //--------------------------------------
    //  Private
    //--------------------------------------

    /**
     * @inheritDoc
     */
    override protected function createChildren():void {
    }

    //--------------------------------------
    //  Public
    //--------------------------------------

    /**
     * @inheritDoc
     */
    override public function draw():void {
        super.draw();
    }
}
}

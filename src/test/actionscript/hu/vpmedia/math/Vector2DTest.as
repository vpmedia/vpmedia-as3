/*
 * =BEGIN CLOSED LICENSE
 *
 * Copyright (c) 2013 Andras Csizmadia
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
package hu.vpmedia.math {
import flash.display.Sprite;

import flexunit.framework.Assert;

public class Vector2DTest extends Sprite {
    private var vector2D:Vector2D;

    [Before]
    public function setUp():void {
        vector2D = new Vector2D();
    }

    [After]
    public function tearDown():void {
        vector2D = null;
    }

    [Test]
    public function test_instantiate():void {
        Assert.assertNotNull(vector2D);
    }
}
}

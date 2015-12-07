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

package hu.vpmedia.framework {
import flash.display.Sprite;

import org.flexunit.Assert;

public class BaseConfigTest extends Sprite {
    private var config:BaseConfig;

    public function BaseConfigTest() {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Before and After
    //
    //--------------------------------------------------------------------------

    [Before]
    public function runBeforeEveryTest():void {
        // implement
        config = new BaseConfig(null);
    }

    [After]
    public function runAfterEveryTest():void {
        // implement
        config.dispose();
        config = null;
    }

    //--------------------------------------------------------------------------
    //
    //  Tests
    //
    //--------------------------------------------------------------------------

    [Test]
    public function test_setupDefaults():void {
        Assert.assertNull(config.setupDefaults());
    }

    [Test]
    public function test_dispose():void {
        Assert.assertNull(config.dispose());
    }

    [Test]
    public function test_copyProperties():void {
        config.copyProperties({a: "a"})
        Assert.assertFalse(config.hasOwnProperty("a"));
    }
}
}

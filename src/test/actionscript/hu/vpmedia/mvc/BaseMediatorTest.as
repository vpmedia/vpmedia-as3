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

package hu.vpmedia.mvc {
import flash.display.Sprite;

import org.flexunit.Assert;

public class BaseMediatorTest extends Sprite {
    private var mediator:BaseMediator;

    public function BaseMediatorTest() {
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
        mediator = new MockMediator(null);
    }

    [After]
    public function runAfterEveryTest():void {
        mediator = null;
    }

    //--------------------------------------------------------------------------
    //
    //  Tests
    //
    //--------------------------------------------------------------------------

    [Test]
    public function test_dispose():void {
        Assert.assertNull(mediator.dispose());
    }
}
}

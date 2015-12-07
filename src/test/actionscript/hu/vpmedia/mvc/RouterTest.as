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

import hu.vpmedia.utils.DictionaryUtil;

import org.flexunit.Assert;

public class RouterTest extends Sprite {
    private var router:Router;
    private var model:BaseModel;
    private var rootView:IBaseView;

    public function RouterTest() {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Before and After
    //
    //--------------------------------------------------------------------------

    [Before]
    public function runBeforeEveryTest():void {
        model = new BaseModel();
        rootView = new MockView();
        router = new Router(model, rootView);
    }

    [After]
    public function runAfterEveryTest():void {
        router = null;
    }

    //--------------------------------------------------------------------------
    //
    //  Tests
    //
    //--------------------------------------------------------------------------

    [Test]
    public function test_currentURL_defaultIsNull():void {
        Assert.assertNull(router.currentURL());
    }

    [Test]
    public function test_previousURL_defaultIsNull():void {
        Assert.assertNull(router.previousURL());
    }

    [Test]
    public function test_isTransitioning_defaultIsFalse():void {
        Assert.assertFalse(router.isTransitioning());
    }

    [Test]
    public function test_getStateMachine():void {
        Assert.assertNotNull(router.stateMachine);
    }

    [Test]
    public function test_addRoute():void {
        var route:RouterItem = new RouterItem();
        router.addRoute(route);
        Assert.assertEquals(DictionaryUtil.keys(router.stateMachine.states).length, 1);
    }

    [Test]
    public function test_addRoutes():void {
        var routeA:RouterItem = new RouterItem({url: "/"});
        var routeB:RouterItem = new RouterItem({url: "/B/"});
        router.addRoutes([routeA, routeB]);
        Assert.assertEquals(DictionaryUtil.keys(router.stateMachine.states).length, 2);
    }
}
}

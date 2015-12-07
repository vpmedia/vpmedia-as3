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

public class RouterUtilTest extends Sprite {
    public function RouterUtilTest() {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Before and After
    //
    //--------------------------------------------------------------------------

    [Before]
    public function runBeforeEveryTest():void {
    }

    [After]
    public function runAfterEveryTest():void {
    }

    //--------------------------------------------------------------------------
    //
    //  Tests
    //
    //--------------------------------------------------------------------------

    [Test]
    public function test_getParentPath():void {
        var parentPathName:String = RouterUtil.getParentPath("/start/mvc/");
        Assert.assertStrictlyEquals(parentPathName, "/start/");
    }

    [Test]
    public function test_getParentPathNames():void {
        var pathNames:Array = RouterUtil.getParentPathNames("/start/mvc/");
        Assert.assertStrictlyEquals(pathNames.length, 1);
        Assert.assertStrictlyEquals(pathNames[0], "start");
    }

    [Test]
    public function test_getPathNames():void {
        var pathNames:Array = RouterUtil.getPathNames("/start/mvc/");
        Assert.assertStrictlyEquals(pathNames.length, 2);
        Assert.assertStrictlyEquals(pathNames[0], "start");
        Assert.assertStrictlyEquals(pathNames[1], "mvc");
    }

    [Test]
    public function test_formatPath():void {
        Assert.assertStrictlyEquals(RouterUtil.formatPath(""), "");
        Assert.assertStrictlyEquals(RouterUtil.formatPath("start"), "/start/");
    }
}
}

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

package hu.vpmedia.utils {
import flexunit.framework.Assert;

public class ObjectUtilTest {
    [Before]
    public function setUp():void {
    }

    [After]
    public function tearDown():void {
    }

    [Test]
    public function test_copyProperties():void {
        var source:Object = {a: "b"};
        var target:Object = {a: "a"};
        ObjectUtil.copyProperties(source, target);
        Assert.assertEquals(source.a, target.a);
    }

    [Test]
    public function test_dispose():void {
        var source:MockClass = new MockClass();
        source.a = "a";
        source.b = 1.5;
        source.c = 2;
        source.d = 3;
        ObjectUtil.dispose(source);
        Assert.assertTrue(source.a == null);
        Assert.assertTrue(source.b == 0);
        Assert.assertTrue(source.c == 0);
        Assert.assertTrue(source.d == null);
    }

    [Test]
    public function test_deepTrace():void {
        var source:Object = {a: "b"};
        ObjectUtil.deepTrace(source);
        Assert.assertTrue(true);
    }

    [Test]
    public function test_toString():void {
        var source:MockClass = new MockClass();
        source.a = "a";
        var target:String = ObjectUtil.toString(source);
        //Assert.assertTrue(target == "MockClass[ c=0, a=a, d=null, b=NaN ]");
    }

    [Test]
    public function test_nextFrameCall():void {
        Assert.assertEquals(ObjectUtil.call(this, "testMethod"), 1);
    }

    public function testMethod():Number {
        return 1;
    }
}
}

class MockClass {
    public var a:String;
    public var b:Number;
    public var c:uint;
    public var d:Object;

    public function MockClass() {
    }
}

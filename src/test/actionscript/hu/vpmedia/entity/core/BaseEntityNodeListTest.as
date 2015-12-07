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

package hu.vpmedia.entity.core {
import org.flexunit.Assert;

public class BaseEntityNodeListTest {
    private var subject:BaseEntityNodeList;

    public function BaseEntityNodeListTest() {
    }

    //--------------------------------------------------------------------------
    //
    //  Before and After
    //
    //--------------------------------------------------------------------------

    [Before]
    public function runBeforeEveryTest():void {
        subject = new BaseEntityNodeList();
    }

    [After]
    public function runAfterEveryTest():void {
        subject.dispose();
        subject = null;
    }

    //--------------------------------------------------------------------------
    //
    //  Tests
    //
    //--------------------------------------------------------------------------

    [Test]
    public function test_add_remove():void {
        var node:BaseEntityNode = new BaseEntityNode();
        Assert.assertTrue(subject.length == 0);
        subject.add(node);
        Assert.assertTrue(subject.length == 1);
        subject.remove(node);
        Assert.assertTrue(subject.length == 0);
    }

    [Test]
    public function test_length():void {
        for (var i:uint = 0; i <= 10; i++) {
            var node:BaseEntityNode = new BaseEntityNode();
            Assert.assertTrue(subject.length == i);
            subject.add(node);
            Assert.assertTrue(subject.length == (i + 1));
        }
        subject.dispose();
        Assert.assertTrue(subject.length == 0);
    }

    [Test]
    public function test_dispose():void {
        subject.dispose();
        var node:BaseEntityNode = new BaseEntityNode();
        subject.add(node);
        subject.dispose();
        Assert.assertNotNull(node);
        Assert.assertTrue(subject.length == 0);
    }
}
}
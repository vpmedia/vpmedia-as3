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
import flash.utils.ByteArray;

import flexunit.framework.Assert;

public class ByteArrayUtilTest {
    [Before]
    public function setUp():void {
    }

    [After]
    public function tearDown():void {
    }

    [Test]
    public function test_clone():void {
        const source:ByteArray = new ByteArray();
        source.writeBoolean(true);
        const target:ByteArray = ByteArrayUtil.clone(source);
        source.position = target.position = 0;
        Assert.assertEquals(source.readBoolean(), target.readBoolean());
    }

    [Test]
    public function test_equals_true():void {
        const source:ByteArray = new ByteArray();
        source.writeUTF("test");
        const target:ByteArray = new ByteArray();
        target.writeUTF("test");
        source.position = target.position = 0;
        Assert.assertTrue(ByteArrayUtil.equals(source, target));
    }

    [Test]
    public function test_equals_false():void {
        const source:ByteArray = new ByteArray();
        source.writeUTF("test");
        const target:ByteArray = new ByteArray();
        target.writeUTF("TEST");
        source.position = target.position = 0;
        Assert.assertFalse(ByteArrayUtil.equals(source, target));
    }

    [Test]
    public function test_dump():void {
        const value:uint = 2082107164;
        const source:ByteArray = new ByteArray();
        source.writeUnsignedInt(value);
        source.position = 0;
        const read:uint = source.readUnsignedInt();
        Assert.assertEquals(value, read);
        Assert.assertEquals(ByteArrayUtil.dump(source, true), "7C 1A 6F 1C ");
        Assert.assertEquals(ByteArrayUtil.dump(source, false), "124 26 111 28 ");
    }

    [Test]
    public function test_split():void {
        const source:ByteArray = new ByteArray();
        source.writeUTF("test");
        const target:ByteArray = ByteArrayUtil.split(source, 0, int(source.length / 2));
        Assert.assertNotNull(target);
    }
}
}

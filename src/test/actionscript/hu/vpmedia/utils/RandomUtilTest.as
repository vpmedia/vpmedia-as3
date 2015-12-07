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

/**
 * TBD
 * @author Andras Csizmadia
 */
public class RandomUtilTest {
    [Before]
    public function setUp():void {
    }

    [After]
    public function tearDown():void {
    }

    [Test]
    public function test_bit():void {
        var v:int = RandomUtil.bit();
        Assert.assertTrue(v == 0 || v == 1);
    }

    [Test]
    public function test_bool():void {
        var v:Boolean = RandomUtil.bool();
        Assert.assertTrue(v == true || v == false);
    }

    [Test]
    public function test_char():void {
        var v:String = RandomUtil.char();
        Assert.assertTrue(RandomUtil.CHARS.indexOf(v) > -1);
    }

    [Test]
    public function test_float():void {
        var v:int = RandomUtil.float(5, 10);
        Assert.assertTrue(v >= 5 && v <= 10);
    }

    [Test]
    public function test_integer():void {
        var v:int = RandomUtil.integer(5, 10);
        Assert.assertTrue(v >= 5 && v <= 10);
    }

    [Test]
    public function test_sign():void {
        var v:int = RandomUtil.sign();
        Assert.assertTrue(v == 1 || v == -1);
    }

    [Test]
    public function test_string():void {
        var size:uint = 4;
        var v:String = RandomUtil.string(size);
        Assert.assertTrue(v.length == size);
    }
}
}

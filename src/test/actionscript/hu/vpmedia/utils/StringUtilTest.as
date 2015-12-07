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

public class StringUtilTest {
    [Before]
    public function setUp():void {
    }

    [After]
    public function tearDown():void {
    }

    [Test]
    public function test_addLeadingZero():void {
        Assert.assertEquals(StringUtil.addLeadingZero(0), "00");
        Assert.assertEquals(StringUtil.addLeadingZero(1), "01");
        Assert.assertEquals(StringUtil.addLeadingZero(10), "10");
        Assert.assertEquals(StringUtil.addLeadingZero(100), "100");
    }

    [Test]
    public function test_substitute():void {
        Assert.assertEquals(StringUtil.substitute("a{0}{1}{2}", 1, 2, 3), "a123");
    }

    [Test]
    public function test_replace():void {
        Assert.assertEquals(StringUtil.replace("a{0}23", "{0}", "1"), "a123");
    }

    [Test]
    public function test_normalize():void {
        Assert.assertEquals(StringUtil.normalize("a"), "a");
    }

    [Test]
    public function test_trim():void {
        Assert.assertEquals(StringUtil.trim(" a "), "a");
    }

    [Test]
    public function test_trimLeft():void {
        Assert.assertEquals(StringUtil.trimLeft(" a "), "a ");
    }

    [Test]
    public function test_trimRight():void {
        Assert.assertEquals(StringUtil.trimRight(" a "), " a");
    }

    [Test]
    public function test_stripTags():void {
        Assert.assertEquals(StringUtil.stripTags("<a>a</a>"), "a");
    }

    [Test]
    public function test_beginsWith():void {
        Assert.assertEquals(StringUtil.beginsWith("ab", "b"), false);
        Assert.assertEquals(StringUtil.beginsWith("ab", "a"), true);
    }

    [Test]
    public function test_endsWith():void {
        Assert.assertEquals(StringUtil.endsWith("ab", "a"), false);
        Assert.assertEquals(StringUtil.endsWith("ab", "b"), true);
    }
}
}

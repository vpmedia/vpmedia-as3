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
import flash.utils.Dictionary;

import flexunit.framework.Assert;

public class DictionaryUtilTest {
    [Before]
    public function setUp():void {
    }

    [After]
    public function tearDown():void {
    }

    [Test]
    public function test_getKeys():void {
        const dict:Dictionary = new Dictionary();
        dict["key"] = "value";
        Assert.assertEquals(DictionaryUtil.keys(dict).length, 1);
        Assert.assertEquals(DictionaryUtil.keys(dict)[0], "key");
    }

    [Test]
    public function test_getValues():void {
        const dict:Dictionary = new Dictionary();
        dict["key"] = "value";
        Assert.assertEquals(DictionaryUtil.values(dict).length, 1);
        Assert.assertEquals(DictionaryUtil.values(dict)[0], "value");
    }

    [Test]
    public function test_clear():void {
        const dict:Dictionary = new Dictionary();
        dict["key"] = "value1";
        dict[1] = "value2";
        dict[{}] = "value3";
        dict[[]] = "value4";
        Assert.assertEquals(DictionaryUtil.clear(dict), 4);
        Assert.assertEquals(DictionaryUtil.length(dict), 0);
    }

    [Test]
    public function test_length():void {
        const dict:Dictionary = new Dictionary();
        dict["key"] = "value1";
        dict[1] = "value2";
        dict[{}] = "value3";
        dict[[]] = "value4";
        Assert.assertEquals(DictionaryUtil.length(dict), 4);
    }
}
}

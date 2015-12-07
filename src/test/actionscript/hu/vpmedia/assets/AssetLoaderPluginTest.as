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
package hu.vpmedia.assets {
import flexunit.framework.Assert;

import hu.vpmedia.assets.parsers.ZIPParser;

public class AssetLoaderPluginTest {
    [Before]
    public function setUp():void {
        AssetLoaderPlugin.register(new ZIPParser());
    }

    [After]
    public function tearDown():void {
    }

    [Test]
    public function testRegisterAndGetSuccess():void {
        AssetLoaderPlugin.register(new MockParser());
        Assert.assertNotNull(AssetLoaderPlugin.getParserByUrl("file.mck"));
    }

    [Test]
    public function testRegisterDoublyFails():void {
        AssetLoaderPlugin.register(new MockParser());
        Assert.assertFalse(AssetLoaderPlugin.register(new MockParser()));
    }
}
}

import hu.vpmedia.assets.parsers.BaseAssetParser;

class MockParser extends BaseAssetParser {
    public function MockParser() {
        super();
        _type = "NULL";
        _pattern = /^.+\.((mck))/i;
    }
}
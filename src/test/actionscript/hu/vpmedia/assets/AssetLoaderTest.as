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

public class AssetLoaderTest {
    private var loader:AssetLoader;

    [Before]
    public function setUp():void {
        loader = new AssetLoader();
    }

    [After]
    public function tearDown():void {
        loader.dispose();
        loader = null;
    }

    [BeforeClass]
    public static function setUpBeforeClass():void {
    }

    [AfterClass]
    public static function tearDownAfterClass():void {
    }

    [Test]
    public function testAddItem():void {
        loader.name = "testAddItemLoader";
        loader.add("test.txt");
        Assert.assertTrue(loader.numTotal == 1);
    }

    /* [Test]
     public function testUnexistingItem():void
     {
     var loader:AssetLoader = new AssetLoader();
     loader.name = "testUnexistingItemLoader";
     loader.add("unknown1");
     loader.execute();
     } */

    [Test]
    public function testLoadItemPriorityQueue():void {
        loader.name = "testLoadItemPriorityQueueLoader";
        loader.add("test.xml", 10);
        loader.add("test.jpg", 5);
        loader.add("test.json", 3);
        loader.add("test.png", 20);
        loader.add("test.txt", 0);
        loader.add("test.swf", 30);
        loader.add("test.mp3", 40);
        loader.add("test.zip", 50);
        loader.add("test.css", 4);
        //loader.execute();
    }

    /* [Test]
     public function testInvalidContent():void
     {
     loader.name = "testInvalidContentLoader";
     loader.add("test-bad.xml");
     loader.add("test-bad.json");
     loader.add("test-bad.png");
     loader.add("test-bad.swf");
     //loader.add("test-bad.zip");// goes to timeout
     loader.execute();
     } */
}
}
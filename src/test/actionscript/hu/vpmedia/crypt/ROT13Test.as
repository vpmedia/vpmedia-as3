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
package hu.vpmedia.crypt {
import flash.utils.ByteArray;

import flexunit.framework.Assert;

public class ROT13Test {
    [Before]
    public function setUp():void {
    }

    [After]
    public function tearDown():void {
    }

    [BeforeClass]
    public static function setUpBeforeClass():void {
    }

    [AfterClass]
    public static function tearDownAfterClass():void {
    }

    [Test]
    public function calculateUTF_test():void {
        const input:String = "Man is distinguished, not only by his reason, but by this singular passion from other animals, which is a lust of the mind, that by a perseverance of delight in the continued and indefatigable generation of knowledge, exceeds the short vehemence of any carnal pleasure.";
        const encoded:String = ROT13.calculateUTF(input);
        const decoded:String = ROT13.calculateUTF(encoded);
        Assert.assertEquals(input, decoded);
    }

    [Test]
    public function calculateInt_test():void {
        const input:int = int.MAX_VALUE;
        const encoded:int = ROT13.calculateInt(input);
        const decoded:int = ROT13.calculateInt(encoded);
        Assert.assertEquals(input, decoded);
    }

    [Test]
    public function calculate_test():void {
        const input:ByteArray = new ByteArray();
        input.writeInt(int.MAX_VALUE);
        input.position = 0;
        const encoded:ByteArray = ROT13.calculate(input);
        const decoded:ByteArray = ROT13.calculate(encoded);
        Assert.assertEquals(input.readInt(), decoded.readInt());
    }
}
}
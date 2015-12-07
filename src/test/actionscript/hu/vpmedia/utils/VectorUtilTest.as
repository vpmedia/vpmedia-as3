/*
 * =BEGIN CLOSED LICENSE
 *
 *  Copyright (c) 2014 Andras Csizmadia
 *  http://www.vpmedia.eu
 *
 *  For information about the licensing and copyright please
 *  contact us at info@vpmedia.eu
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 *
 * =END CLOSED LICENSE
 */

package hu.vpmedia.utils {
import flexunit.framework.Assert;

public class VectorUtilTest {
    [Before]
    public function setUp():void {
    }

    [After]
    public function tearDown():void {
    }

    [Test]
    public function test_2d():void {
        const s:String = "0,1|2,3";
        const r:Vector.<Vector.<int>> = VectorUtil.parse2DIntVector(s, "|", ",");
        Assert.assertEquals(r[0][1], 1);
        Assert.assertEquals(r[1][0], 2);
        Assert.assertEquals(r[1][1], 3);
    }

    [Test]
    public function test_3d():void {
        const s:String = "0,1|2,3;4,5|6,7";
        const r:Vector.<Vector.<Vector.<int>>> = VectorUtil.parse3DIntVector(s, ";", "|", ",");
        Assert.assertEquals(r[0][0][1], 1);
        Assert.assertEquals(r[0][1][0], 2);
        Assert.assertEquals(r[0][1][1], 3);

    }

    [Test]
    public function test_4d():void {
        const s:String = "0,1|2,3;4,5|6,7||0,1|2,3;4,5|6,7";
        const r:Vector.<Vector.<Vector.<Vector.<int>>>> = VectorUtil.parse4DIntVector(s, "||", ";", "|", ",");
        Assert.assertEquals(r[0][0][0][1], 1);
        Assert.assertEquals(r[0][0][1][0], 2);
        Assert.assertEquals(r[0][0][1][1], 3);
    }

    [Test]
    public function test_5d():void {
        const s:String = "1-2,3-4|1-2,3-4;1-2,3-4|1-2,3-4||1-2,3-4|1-2,3-4;1-2,3-4|1-2,3-4";
        const r:Vector.<Vector.<Vector.<Vector.<Vector.<int>>>>> = VectorUtil.parse5DIntVector(s, "||", ";", "|", ",", "-");
        Assert.assertEquals(r[0][0][0][0][0], 1);
        Assert.assertEquals(r[0][0][0][0][1], 2);
    }
}
}

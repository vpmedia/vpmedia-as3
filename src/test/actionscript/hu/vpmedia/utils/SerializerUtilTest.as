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
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.geom.Rectangle;

import flexunit.framework.Assert;

/**
 * TBD
 * @author Andras Csizmadia
 */
public class SerializerUtilTest {
    [Before]
    public function setUp():void {
    }

    [After]
    public function tearDown():void {
    }

    [Test]
    public function test_pointFromString():void {
        var sourceRect:Point = new Point(1, 2);
        var rectString:String = sourceRect.toString();
        var parsedRect:Point = SerializerUtil.pointFromString(rectString);
        Assert.assertEquals(sourceRect.x, parsedRect.x);
        Assert.assertEquals(sourceRect.y, parsedRect.y);
    }

    [Test]
    public function test_isPointString():void {
        Assert.assertTrue(SerializerUtil.isPointString(new Point().toString()));
    }

    [Test]
    public function test_fromString():void {
        var sourceRect:Rectangle = new Rectangle(1, 2, 3, 4);
        var rectString:String = sourceRect.toString();
        var parsedRect:Rectangle = SerializerUtil.rectangleFromString(rectString);
        Assert.assertEquals(sourceRect.x, parsedRect.x);
        Assert.assertEquals(sourceRect.y, parsedRect.y);
        Assert.assertEquals(sourceRect.width, parsedRect.width);
        Assert.assertEquals(sourceRect.height, parsedRect.height);
    }

    [Test]
    public function test_isRectangleString():void {
        Assert.assertTrue(SerializerUtil.isRectangleString(new Rectangle().toString()));
    }

    [Test]
    public function test_decode():void {
        var source:Object = {__type: "flash.filters::DropShadowFilter", blurX: 2, blurY: 3, quality: 1};
        var target:* = SerializerUtil.decode(source);
        Assert.assertTrue(target is DropShadowFilter);
        Assert.assertTrue(target.blurX == 2);
        Assert.assertTrue(target.blurY == 3);
        Assert.assertTrue(target.quality == 1);
    }

    [Test]
    public function test_decodeList():void {
        var source:Object = {__type: "flash.filters::DropShadowFilter", blurX: 2, blurY: 3, quality: 1};
        var targets:Array = SerializerUtil.decodeList([source]);
        var target:DropShadowFilter = targets[0];
        Assert.assertTrue(target is DropShadowFilter);
        Assert.assertTrue(target.blurX == 2);
        Assert.assertTrue(target.blurY == 3);
        Assert.assertTrue(target.quality == 1);
    }
}
}

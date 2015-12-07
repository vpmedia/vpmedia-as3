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
package hu.vpmedia.serializers {
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;

import flexunit.framework.Assert;

public class SerializerTest extends Sprite {
    private var serializer:Serializer;

    [Before]
    public function setUp():void {
        serializer = new Serializer();
    }

    [After]
    public function tearDown():void {
        serializer = null;
    }

    [Test]
    public function test_serialize_point():void {
        const source:Point = new Point(10, 10);
        const encoded:Object = serializer.encode(source);
        Assert.assertNotNull(encoded);
        const decoded:Point = serializer.decode(encoded);
        Assert.assertNotNull(decoded);
        Assert.assertEquals(encoded.__type, "flash.geom::Point");
        Assert.assertEquals(encoded.x, decoded.x, 10);
        Assert.assertEquals(encoded.y, decoded.y, 10);
    }

    [Test]
    public function test_serialize_rectangle():void {
        const source:Rectangle = new Rectangle(10, 10, 10, 10);
        const encoded:Object = serializer.encode(source);
        Assert.assertNotNull(encoded);
        const decoded:Rectangle = serializer.decode(encoded);
        Assert.assertNotNull(decoded);
        Assert.assertEquals(encoded.__type, "flash.geom::Rectangle");
        Assert.assertEquals(encoded.x, decoded.x, 10);
        Assert.assertEquals(encoded.y, decoded.y, 10);
        Assert.assertEquals(encoded.width, decoded.width, 10);
        Assert.assertEquals(encoded.height, decoded.height, 10);
    }

    /* [Test]
     public function test_serialize_vector2d():void {
     const source:Vector2D = new Vector2D(10, 10);
     const encoded:Object = serializer.encode(source);
     Assert.assertNotNull(encoded);
     const decoded:Vector2D = serializer.decode(encoded);
     Assert.assertNotNull(decoded);
     Assert.assertEquals(encoded.__type, "hu.vpmedia.math::Vector2D");
     Assert.assertEquals(int(decoded.x), 10);
     Assert.assertEquals(int(decoded.y), 10);
     }  */

    [Test]
    public function test_serialize_mock():void {
        const source:MockClass = new MockClass();
        const encoded:Object = serializer.encode(source);
        Assert.assertNotNull(encoded);
        const decoded:MockClass = serializer.decode(encoded);
        Assert.assertNotNull(decoded);
        Assert.assertEquals(encoded.__type, "hu.vpmedia.serializers::MockClass");
        Assert.assertEquals(decoded.point.x, 10);
        Assert.assertEquals(decoded.rectangle.x, 10);
        Assert.assertEquals(int(decoded.vector2D.x), 10);
    }
}
}


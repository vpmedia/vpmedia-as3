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

package hu.vpmedia.entity.core {
import hu.vpmedia.serializers.Serializer;
import hu.vpmedia.serializers.utils.XMLDefinition;

import org.flexunit.asserts.*;

public class BaseEntitySerializerTest {
    public function BaseEntitySerializerTest() {
    }

    //--------------------------------------------------------------------------
    //
    //  Before and After
    //
    //--------------------------------------------------------------------------

    [Before]
    public function runBeforeEveryTest():void {
    }

    [After]
    public function runAfterEveryTest():void {
    }

    //--------------------------------------------------------------------------
    //
    //  Tests
    //
    //--------------------------------------------------------------------------

    [Test]
    public function canRunSerializer():void {
        var world:BaseEntityWorld = new BaseEntityWorld();
        var entity:BaseEntity = new BaseEntity();
        world.addEntity(entity);
        var xml:XML = toXML(world);
        assertNotNull(xml);
    }

    //--------------------------------------------------------------------------
    //
    //  Helper methods
    //
    //--------------------------------------------------------------------------

    private function toXML(world:BaseEntityWorld):XML {
        var serializer:Serializer = new Serializer();
        serializer.addSerializer(BaseEntitySerializer);

        var list:BaseEntityList = world.getEntityList();
        var result:String = "<entities>";
        for (var entity:BaseEntity = list.head; entity; entity = entity.next) {
            var encodedEntity:Object = serializer.encode(entity);
            result += XMLDefinition.create(encodedEntity);
        }
        result += "</entities>";
        var xml:XML = new XML(result);
        return xml;
    }
}
}
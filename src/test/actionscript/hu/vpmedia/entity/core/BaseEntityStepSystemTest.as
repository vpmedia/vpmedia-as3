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
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;

public class BaseEntityStepSystemTest {
    private var entities:Vector.<BaseEntity>;
    private var callCount:int;

    public function BaseEntityStepSystemTest() {
    }

    [Test]
    public function updateIteratesOverNodes():void {
        var engine:BaseEntityWorld = new BaseEntityWorld();
        var entity1:BaseEntity = new BaseEntity();
        entity1.addComponent(new MockComponentA());
        entity1.addComponent(new MockComponentB());
        engine.addEntity(entity1);
        var entity2:BaseEntity = new BaseEntity();
        entity2.addComponent(new MockComponentA());
        entity2.addComponent(new MockComponentB());
        engine.addEntity(entity2);
        var entity3:BaseEntity = new BaseEntity();
        entity3.addComponent(new MockComponentA());
        entity3.addComponent(new MockComponentB());
        engine.addEntity(entity3);

        var system:BaseEntityStepSystem = new BaseEntityStepSystem(engine, MockNode, updateNode);
        engine.addSystem(system, 1);
        entities = new <BaseEntity>[entity1, entity2, entity3];
        callCount = 0;
        engine.step(0.1);
        assertThat(callCount, equalTo(3));
    }

    private function updateNode(node:MockNode, time:Number):void {
        assertThat(node.data, equalTo(entities[callCount]));
        assertThat(time, equalTo(0.1));
        callCount++;
    }

}
}
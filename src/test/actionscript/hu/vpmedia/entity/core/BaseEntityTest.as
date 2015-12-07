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
import flash.display.Sprite;

import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertStrictlyEquals;
import org.flexunit.asserts.assertTrue;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
public class BaseEntityTest extends Sprite {
    private var world:BaseEntityWorld;
    private var entity:BaseEntity;

    public function BaseEntityTest() {
        //new FlexSprite();
        //new FlexBitmap();
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Before and After
    //
    //--------------------------------------------------------------------------
    [Before]
    public function runBeforeEveryTest():void {
        world = new BaseEntityWorld();
        entity = new BaseEntity();
    }

    [After]
    public function runAfterEveryTest():void {
        world = null;
        entity = null;
    }

    //--------------------------------------------------------------------------
    //
    //  Tests
    //
    //--------------------------------------------------------------------------

    [Test]
    public function can_remove_entity():void {
        world.addEntity(entity);
        world.removeEntity(entity);
        // assertFalse(world.contains(entity));
    }

    [Test]
    public function can_add_entity_to_world():void {
        world.addEntity(entity);
    }

    [Test]
    public function can_add_component_to_entity():void {
        entity.addComponent(new MockComponentA());
        assertTrue(entity.hasComponent(MockComponentA));
    }

    [Test]
    public function can_reference_component_instance_by_class():void {
        var component:MockComponentA = new MockComponentA();
        entity.addComponent(component);
        assertStrictlyEquals(entity.getComponent(MockComponentA), component);
    }

    [Test]
    public function can_remove_component_from_entity():void {
        entity.addComponent(new MockComponentA());
        entity.removeComponent(MockComponentA);
        assertFalse(entity.hasComponent(MockComponentA));
    }
}
}

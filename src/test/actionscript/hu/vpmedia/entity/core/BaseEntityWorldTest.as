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
import org.flexunit.Assert;

public class BaseEntityWorldTest {
    private var world:BaseEntityWorld;
    private var entity:BaseEntity;

    public function BaseEntityWorldTest() {
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
    public function test_addGetRemoveEntity():void {
        var world:BaseEntityWorld = new BaseEntityWorld();
        var entity:BaseEntity = new BaseEntity();
        entity.addComponent(new MockComponentA());
        entity.addComponent(new MockComponentB());
        entity.addComponent(new MockComponentC());

        world.addEntity(entity);

        Assert.assertTrue(world.hasEntity(entity));

        Assert.assertStrictlyEquals(world.getEntityList().head, entity);
        Assert.assertStrictlyEquals(world.getEntityList().tail, entity);

        world.removeEntity(entity);

        Assert.assertNull(world.getEntityList().head);
        Assert.assertNull(world.getEntityList().tail);
    }
}
}
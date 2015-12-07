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
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertTrue;

public class BaseEntitySystemTest {
    private var world:BaseEntityWorld;
    private var entity:BaseEntity;

    public function BaseEntitySystemTest() {
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
    public function can_add_system_to_world():void {
        world.addSystem(new MockSystem(world));
    }

    [Test]
    public function can_get_a_system_from_world():void {
        world.addSystem(new MockSystem(world));
        var mock:BaseEntitySystem = world.getSystem(MockSystem);
        assertTrue(mock is MockSystem);
    }

    [Test]
    public function can_remove_a_system_from_world():void {
        world.addSystem(new MockSystem(world));
        world.removeSystem(MockSystem);
        assertFalse(world.getSystem(MockSystem));
    }

    [Test(expects="Error")]
    public function adding_an_inavlid_system__fails():void {
        world.createSystem(MockNode);
    }

    [Test(expects="Error")]
    public function adding_a_system_twice_fails():void {
        world.addSystem(new MockSystem(world));
        world.addSystem(new MockSystem(world));
    }
}
}
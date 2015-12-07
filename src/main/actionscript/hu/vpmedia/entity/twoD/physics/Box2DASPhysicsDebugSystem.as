/*
 * =BEGIN CLOSED LICENSE
 *
 * Copyright (c) 2013-2014 Andras Csizmadia
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
package hu.vpmedia.entity.twoD.physics {
import Box2DAS.Dynamics.b2DebugDraw;

import hu.vpmedia.entity.core.BaseEntitySystem;
import hu.vpmedia.entity.core.BaseEntityWorld;
import hu.vpmedia.entity.twoD.physics.utils.Box2DASRegistry;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
public class Box2DASPhysicsDebugSystem extends BaseEntitySystem {
    private var _debug:b2DebugDraw;

    private var _world:BaseEntityWorld;

    public function Box2DASPhysicsDebugSystem(world:BaseEntityWorld) {
        _world = world;
        initialize();
    }

    private function initialize():void {
        _debug = new b2DebugDraw(Box2DASRegistry.world, Box2DASRegistry.scale);
        _world.context.addChildAt(_debug, 0);
    }

    override public function dispose():void {
        _world.context.removeChild(_debug);
        _debug = null;
        super.dispose();
    }

    override public function step(timeDelta:Number):void {
        _debug.Draw();
    }
}
}

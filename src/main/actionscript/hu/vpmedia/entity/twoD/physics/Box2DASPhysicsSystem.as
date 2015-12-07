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
import Box2DAS.Common.V2;
import Box2DAS.Common.b2Base;
import Box2DAS.Dynamics.b2World;

import hu.vpmedia.entity.core.BaseEntitySystem;
import hu.vpmedia.entity.core.BaseEntityWorld;
import hu.vpmedia.entity.twoD.physics.utils.Box2DASRegistry;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
public class Box2DASPhysicsSystem extends BaseEntitySystem {
    private var _config:BasePhysics2DVars;

    private var _b2world:b2World;

    private var _world:BaseEntityWorld;

    public function Box2DASPhysicsSystem(world:BaseEntityWorld, params:Object = null) {
        _world = world;
        _config = new BasePhysics2DVars(params);
        initialize();
    }

    protected function initialize():void {
        BasePhysics2DCollisionCategories.setDefaults();
        b2Base.initialize();
        _b2world = new b2World(new V2(0, 0), _config.allowSleep);
        Box2DASRegistry.world = _b2world;
        Box2DASRegistry.scale = _config.scale;
    }

    override public function dispose():void {
        _b2world.destroy();
        _b2world = null;
        Box2DASRegistry.world = null;
        super.dispose();
    }

    override public function step(timeDelta:Number):void {
        // _config.timeStep
        _b2world.Step(_config.timeStep, _config.velocityIterations, _config.positionIterations);
    }
}
}

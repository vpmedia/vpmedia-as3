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
package hu.vpmedia.entity.threeD.physics {
import away3d.containers.View3D;

import awayphysics.debug.AWPDebugDraw;
import awayphysics.dynamics.AWPDynamicsWorld;

import hu.vpmedia.entity.core.BaseEntitySystem;
import hu.vpmedia.entity.core.BaseEntityWorld;
import hu.vpmedia.entity.threeD.renderers.Away3DRenderSystem;

public class Away3DPhysicsDebugSystem extends BaseEntitySystem {
    private var _physicsStats:AWPDebugDraw;
    private var _world:BaseEntityWorld;

    public function Away3DPhysicsDebugSystem(world:BaseEntityWorld) {
        _world = world;
        initialize();
    }

    private function initialize():void {
        //trace(this, "initialize");
        var _view:View3D = Away3DRenderSystem(_world.getSystem(Away3DRenderSystem)).view;
        var _physics:AWPDynamicsWorld = Away3DPhysicsSystem(_world.getSystem(Away3DPhysicsSystem)).physics;
        _physicsStats = new AWPDebugDraw(_view, _physics);
        _physicsStats.debugMode = AWPDebugDraw.DBG_DrawCollisionShapes | AWPDebugDraw.DBG_DrawRay;
    }

    override public function dispose():void {
        _physicsStats = null;
        super.dispose();
    }

    override public function step(timeDelta:Number):void {
        _physicsStats.debugDrawWorld();
    }
}
}

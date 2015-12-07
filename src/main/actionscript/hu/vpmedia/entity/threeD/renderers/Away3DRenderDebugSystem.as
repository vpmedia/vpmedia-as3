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
package hu.vpmedia.entity.threeD.renderers {
import away3d.containers.View3D;
import away3d.debug.AwayStats;

import hu.vpmedia.entity.core.BaseEntitySystem;
import hu.vpmedia.entity.core.BaseEntityWorld;

public class Away3DRenderDebugSystem extends BaseEntitySystem {
    private var _awayStats:AwayStats;
    private var _world:BaseEntityWorld;

    public function Away3DRenderDebugSystem(world:BaseEntityWorld) {
        _world = world;
        initialize();
    }

    /**
     * Global initialise function
     */
    private function initialize():void {
        //trace(this, "initialize");
        var _view:View3D = Away3DRenderSystem(_world.getSystem(Away3DRenderSystem)).view;
        _awayStats = new AwayStats(_view);
        _world.context.addChild(_awayStats);
    }

    override public function dispose():void {
        _world.context.removeChild(_awayStats);
        _awayStats = null;
        super.dispose();
    }
}
}

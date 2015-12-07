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
import away3d.cameras.Camera3D;
import away3d.cameras.lenses.LensBase;
import away3d.cameras.lenses.PerspectiveLens;
import away3d.containers.Scene3D;
import away3d.containers.View3D;
import away3d.controllers.HoverController;
import away3d.core.managers.Stage3DProxy;
import away3d.core.render.DefaultRenderer;

import hu.vpmedia.entity.core.BaseEntityStepSystem;
import hu.vpmedia.entity.core.BaseEntityWorld;

/**
 * TBD
 */
public class Away3DRenderSystem extends BaseEntityStepSystem {

    /**
     * TBD
     */
    protected var scene:Scene3D;

    /**
     * TBD
     */
    protected var camera:Camera3D;

    /**
     * TBD
     */
    protected var cameraLens:LensBase;

    /**
     * TBD
     */
    protected var renderer:DefaultRenderer;

    /**
     * TBD
     */
    public var view:View3D;

    /**
     * TBD
     */
    public var cameraController:HoverController;

    /**
     * TBD
     */
    protected var config:Away3DRenderConfig;

    /**
     * TBD
     */
    protected var stage3DProxy:Stage3DProxy;

    /**
     * TBD
     */
    public function Away3DRenderSystem(world:BaseEntityWorld, stage3DProxy:Stage3DProxy = null, config:Away3DRenderConfig = null) {
        this.config = config ? config : new Away3DRenderConfig();
        this.stage3DProxy = stage3DProxy;
        super(world, Away3DRenderNode, onStep, onAdded, onRemoved);
        initialize();
    }

    /**
     * TBD
     */
    protected function onStep(node:Away3DRenderNode, timeStep:Number):void {
    }

    /**
     * TBD
     */
    protected function onAdded(node:Away3DRenderNode):void {
        scene.addChild(node.skin);

        onStep(node, 0);
    }

    /**
     * TBD
     */
    protected function onRemoved(node:Away3DRenderNode):void {
        scene.removeChild(node.skin);

        node.skin.dispose();
    }

    /**
     * TBD
     */
    override public function step(timeDelta:Number):void {
        view.render();
    }

    /**
     * Global initialise function
     */
    protected function initialize():void {
        // scene
        scene = new Scene3D();
        // renderer
        renderer = new DefaultRenderer();
        // camera
        cameraLens = new PerspectiveLens(config.cameraFov);
        cameraLens.near = config.cameraLensNear;
        cameraLens.far = config.cameraLensFar;
        camera = new Camera3D(cameraLens);
        // view
        view = new View3D(scene, camera, renderer);
        if (stage3DProxy) {
            view.stage3DProxy = stage3DProxy;
            view.shareContext = true;
        }
        view.antiAlias = config.antiAlias;
        _world.context.addChild(view);
        // camera control
        cameraController = new HoverController(camera, null, config.cameraPanAngle, config.cameraTiltAngle, config.cameraDistance);
    }

    /**
     * TBD
     */
    override public function dispose():void {
        view.stage3DProxy.dispose();
        super.dispose();
    }
}
}

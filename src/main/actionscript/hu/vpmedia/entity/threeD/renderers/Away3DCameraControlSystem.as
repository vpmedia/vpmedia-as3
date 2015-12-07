/*
 * =BEGIN CLOSED LICENSE 
 *  
 *  Copyright(c) 2014 Andras Csizmadia. 
 *  http://www.vpmedia.eu 
 *  
 *  For information about the licensing and copyright please  
 *  contact Andras Csizmadia at andras@vpmedia.eu. 
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 *  
 * =END CLOSED LICENSE
 */
package hu.vpmedia.entity.threeD.renderers {
import away3d.containers.View3D;
import away3d.controllers.HoverController;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

import hu.vpmedia.entity.core.BaseEntitySystem;
import hu.vpmedia.entity.core.BaseEntityWorld;

public class Away3DCameraControlSystem extends BaseEntitySystem {

    private var cameraController:HoverController;

    private var view:View3D;

    private var isMoving:Boolean;

    private var lastPanAngle:Number;

    private var lastTiltAngle:Number;

    private var lastMouseX:Number;

    private var lastMouseY:Number;

    private var tiltIncrement:Number = 0;

    private var panIncrement:Number = 0;

    private var distanceIncrement:Number = 0;

    private var tiltSpeed:Number = 2;

    private var panSpeed:Number = 2;

    private var distanceSpeed:Number = 2;

    private var _world:BaseEntityWorld;

    public function Away3DCameraControlSystem(world:BaseEntityWorld) {
        _world = world;
        view = Away3DRenderSystem(_world.getSystem(Away3DRenderSystem)).view;
        cameraController = Away3DRenderSystem(_world.getSystem(Away3DRenderSystem)).cameraController;
        super();
        initialize();
    }

    private function initialize():void {
        view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
        view.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
        _world.context.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
        _world.context.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);
    }

    override public function dispose():void {
        view.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        view.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        _world.context.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        _world.context.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        super.dispose();
    }

    override public function step(timeDelta:Number):void {
        updateCameraMovement();
        super.step(timeDelta);
    }

    private function onMouseDown(event:MouseEvent):void {
        lastPanAngle = cameraController.panAngle;
        lastTiltAngle = cameraController.tiltAngle;
        lastMouseX = _world.context.stage.mouseX;
        lastMouseY = _world.context.stage.mouseY;
        isMoving = true;
        _world.context.stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
    }

    private function onMouseUp(event:MouseEvent):void {
        isMoving = false;
        _world.context.stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
    }

    private function onStageMouseLeave(event:Event):void {
        isMoving = false;
        _world.context.stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
    }

    private function onKeyDown(event:KeyboardEvent):void {
        switch (event.keyCode) {
            case Keyboard.W:
                tiltIncrement = tiltSpeed;
                break;
            case Keyboard.S:
                tiltIncrement = -tiltSpeed;
                break;
            case Keyboard.A:
                panIncrement = panSpeed;
                break;
            case Keyboard.D:
                panIncrement = -panSpeed;
                break;
            case Keyboard.Z:
                distanceIncrement = distanceSpeed;
                break;
            case Keyboard.X:
                distanceIncrement = -distanceSpeed;
                break;
        }
    }

    private function onKeyUp(event:KeyboardEvent):void {
        switch (event.keyCode) {
            case Keyboard.UP:
            case Keyboard.W:
            case Keyboard.DOWN:
            case Keyboard.S:
                tiltIncrement = 0;
                break;
            case Keyboard.LEFT:
            case Keyboard.A:
            case Keyboard.RIGHT:
            case Keyboard.D:
                panIncrement = 0;
                break;
            case Keyboard.Z:
            case Keyboard.X:
                distanceIncrement = 0;
                break;
        }
    }

    private function updateCameraMovement():void {
        if (isMoving) {
            cameraController.panAngle = 0.3 * (_world.context.stage.mouseX - lastMouseX) + lastPanAngle;
            cameraController.tiltAngle = 0.3 * (_world.context.stage.mouseY - lastMouseY) + lastTiltAngle;
        }
        cameraController.panAngle += panIncrement;
        cameraController.tiltAngle += tiltIncrement;
        cameraController.distance += distanceIncrement;
    }
}
}

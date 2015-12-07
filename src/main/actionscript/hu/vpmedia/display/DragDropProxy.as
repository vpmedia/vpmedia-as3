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
package hu.vpmedia.display {
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.MouseEvent;
import flash.geom.Point;

public class DragDropProxy extends EventDispatcher implements IEventDispatcher {
    private var target:InteractiveObject;
    private var useWeakReference:Boolean;
    private var completeEvent:Event;
    private var renderEvent:Event;
    private var startEvent:Event;
    public var isEnabled:Boolean;
    public var isSnapToGrid:Boolean;
    public var gridSize:uint = 10;
    public var registration:String;
    public var dragPoint:Point;

    public function DragDropProxy(target:InteractiveObject, registration:String = null, useWeakReference:Boolean = true) {
        trace(this, "DragDropProxy", target, registration, useWeakReference);
        this.target = target;
        this.useWeakReference = useWeakReference;
        this.registration = registration;
        if (!target.stage) {
            target.addEventListener(Event.ADDED_TO_STAGE, addedHandler, false, 0, useWeakReference);
        }
        else {
            initialize();
        }
    }

    private function initialize():void {
        //trace(this, "initialize");
        dragPoint = new Point(0, 0);
        switch (registration) {
            case DragAlignTypes.MIDDLE:
            {
                dragPoint.x = target.width / 2;
                dragPoint.y = target.height / 2;
                break;
            }
            /*case DragAlignTypes.TOP_LEFT:
             {
             dragPoint.x = 0;
             dragPoint.y = 0;
             break;
             }*/
        }
        isEnabled = true;
        completeEvent = new Event(Event.COMPLETE, false, false);
        startEvent = new Event(Event.SELECT, false, false);
        renderEvent = new Event(Event.RENDER, false, false);
        target.addEventListener(Event.REMOVED_FROM_STAGE, removedHandler, false, 0, useWeakReference);
        target.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, useWeakReference);
    }

    private function addedHandler(event:Event):void {
        //trace(this, "addedHandler");
        target.removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
        initialize();
    }

    private function removedHandler(event:Event):void {
        //trace(this, "removedHandler");
        dispose();
    }

    public function dispose():void {
        //trace(this, "dispose");
        if (target) {
            if (target.stage) {
                target.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseDownHandler);
                target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
            }
            target.removeEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
            target.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        }
    }

    private function mouseDownHandler(event:MouseEvent):void {
        //trace(this, "mouseDownHandler");
        if (!isEnabled) {
            return;
        }
        if (!registration) {
            dragPoint.x = event.localX;
            dragPoint.y = event.localY;
        }
        dispatchEvent(startEvent.clone());
        target.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, useWeakReference);
        target.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, useWeakReference);
    }

    private function mouseMoveHandler(event:MouseEvent):void {
        //trace(this, "mouseMoveHandler");
        if (isSnapToGrid) {
            target.x = event.stageX - event.stageX % gridSize - dragPoint.x;
            target.y = event.stageY - event.stageY % gridSize - dragPoint.y;
        }
        else {
            target.x = event.stageX - dragPoint.x;
            target.y = event.stageY - dragPoint.y;
        }
        event.updateAfterEvent();
        dispatchEvent(renderEvent.clone());
    }

    private function mouseUpHandler(event:MouseEvent):void {
        //trace(this, "mouseUpHandler");
        if (target && target.stage) {
            target.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseDownHandler);
            target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        }
        dispatchEvent(completeEvent.clone());
    }
}
}

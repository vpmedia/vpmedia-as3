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

import flash.display.Graphics;

import hu.vpmedia.entity.core.BaseEntityStepSystem;
import hu.vpmedia.entity.core.BaseEntityWorld;
import hu.vpmedia.entity.twoD.physics.utils.Box2DASRegistry;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
public class Box2DASRayCastSystem extends BaseEntityStepSystem {

    private static const RAD_TO_DEG:Number = 180 / Math.PI; //57.29577951;

    private static const DEG_TO_RAD:Number = Math.PI / 180; //0.017453293;

    public function Box2DASRayCastSystem(world:BaseEntityWorld, params:Object = null) {
        super(world, Box2DASRayCastNode, onStep, onAdded, onRemoved);
        initialize();
    }

    protected function initialize():void {
    }

    private function onAdded(node:Box2DASRayCastNode):void {
        //trace(this, "onAdded", node);
        node.rayCast.onRayCast.add(onRayCast);
        _world.context.graphics.lineStyle(2, 0xE20074);
    }

    private function onRemoved(node:Box2DASRayCastNode):void {
        //trace(this, "onRemoved", node);
        node.rayCast.onRayCast.remove(onRayCast);
    }

    private function onStep(node:Box2DASRayCastNode, timeDelta:Number):void {
        var rc:Box2DASRayCastComponent = node.rayCast;
        if (!rc.isDirty || rc.numReflection >= rc.maxReflection || rc.totalMagnitude > rc.maxMagniude) {
            //trace(!rc.isDirty, rc.numReflection >= rc.maxReflection, rc.totalMagnitude > rc.maxMagniude);
            return;
        }
        if (rc.magnitude < rc.maxMagniude) {
            rc.magnitude += rc.stepMagnitude;
        }
        if (!rc.isBusy || !rc.hasFound) {
            //trace(rc.isBusy, rc.hasFound);
            var v1:V2 = new V2(rc.x / Box2DASRegistry.scale, rc.y / Box2DASRegistry.scale);
            var tmp:V2 = new V2(rc.magnitude, 0);
            tmp.rotate(rc.rotation * DEG_TO_RAD);
            var v2:V2 = v1.clone().add(tmp);
            rc.doRayCast(v1, v2);
        }
    }

    private function drawLaser(graphics:Graphics, lX:Number, lY:Number, draw:Boolean = true):void {
        if (draw) {
            graphics.lineTo(lX, lY);
        }
        else {
            graphics.moveTo(lX, lY);
        }
    }

    private function drawCircle(graphics:Graphics, x:Number, y:Number, r:Number = 3):void {
        graphics.drawCircle(x, y, r);
    }

    private function onRayCast(laser:Box2DASRayCastComponent):void {
        var s:Number = Box2DASRegistry.scale;
        // laser.skin.graphics.clear();
        _world.context.graphics.lineStyle(2, 0xE20074);
        var sx:Number = laser.startPoint.x * s;
        var sy:Number = laser.startPoint.y * s;
        var fx:Number = laser.foundPoint.x * s;
        var fy:Number = laser.foundPoint.y * s;
        //trace(this, "onRayCast", laser, sx, sy, fx, fy);
        drawLaser(_world.context.graphics, sx, sy, false);
        drawLaser(_world.context.graphics, fx, fy, true);
        if (laser.hasFound) {
            // normal (debug)
            _world.context.graphics.lineStyle(0, 0, 0);
            _world.context.graphics.beginFill(0xFFFF00, 1);
            drawCircle(_world.context.graphics, fx, fy, 2);
            _world.context.graphics.endFill();
            _world.context.graphics.lineStyle(1, 0x0000FF);
            drawLaser(_world.context.graphics, fx, fy, false);
            var normalEnd:V2 = laser.foundPoint.clone().add(laser.foundNormal);
            drawLaser(_world.context.graphics, normalEnd.x * s, normalEnd.y * s, true);
            laser.next();
        }
    }
}
}

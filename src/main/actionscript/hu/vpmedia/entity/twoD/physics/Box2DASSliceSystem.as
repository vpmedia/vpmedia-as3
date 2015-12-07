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
import Box2DAS.Dynamics.b2Fixture;

import flash.display.Graphics;

import hu.vpmedia.entity.core.BaseEntityStepSystem;
import hu.vpmedia.entity.core.BaseEntityWorld;
import hu.vpmedia.entity.twoD.physics.utils.Box2DASRegistry;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
public class Box2DASSliceSystem extends BaseEntityStepSystem {
    private static const RAD_TO_DEG:Number = 180 / Math.PI; //57.29577951;

    private static const DEG_TO_RAD:Number = Math.PI / 180; //0.017453293;

    public function Box2DASSliceSystem(world:BaseEntityWorld, params:Object = null) {
        super(world, Box2DASSliceNode, onStep, onAdded, onRemoved);
        initialize();
    }

    protected function initialize():void {
    }

    private function onAdded(node:Box2DASSliceNode):void {
        //trace(this, "onAdded", node);
        node.rayCast.onSliceCast.add(onSliceCast);
        node.rayCast.onFraction.add(onFraction);
        _world.context.graphics.lineStyle(2, 0xE20074);
    }

    private function onRemoved(node:Box2DASSliceNode):void {
        //trace(this, "onRemoved", node);
        node.rayCast.onSliceCast.remove(onSliceCast);
    }

    private function onStep(node:Box2DASSliceNode, timeDelta:Number):void {
        var rc:Box2DASSliceComponent = node.rayCast;
        if (!rc.isBusy) {
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

    private function onSliceCast(laser:Box2DASSliceComponent):void {
        trace(this, "onSliceCast", laser);
        var s:Number = Box2DASRegistry.scale;
        _world.context.graphics.lineStyle(2, 0xE20074);
        var sx:Number = laser.startPoint.x * s;
        var sy:Number = laser.startPoint.y * s;
        var fx:Number = laser.foundPoint.x * s;
        var fy:Number = laser.foundPoint.y * s;
        var ex:Number = laser.endPoint.x * s;
        var ey:Number = laser.endPoint.y * s;
        drawLaser(_world.context.graphics, sx, sy, false);
        drawLaser(_world.context.graphics, fx, fy, true);
        //_world.context.graphics.lineStyle(2, 0x999999);
        //drawLaser(_world.context.graphics, ex, ey, true);
        //  drawLaser(_world.context.graphics, fx, fy, false);
        // normal (debug)
        _world.context.graphics.lineStyle(0, 0, 0);
        _world.context.graphics.beginFill(0xFFFF00, 1);
        drawCircle(_world.context.graphics, fx, fy, 2);
        _world.context.graphics.endFill();
        _world.context.graphics.lineStyle(1, 0x0000FF);
        drawLaser(_world.context.graphics, fx, fy, false);
        var normalEnd:V2 = laser.foundPoint.clone().add(laser.foundNormal);
        drawLaser(_world.context.graphics, normalEnd.x * s, normalEnd.y * s, true);
        if (laser.isOpposite && laser.rotation < 420) {
            laser.rotation += 15;
            laser.reset();
        }
    }

    private function onFraction(fixture:b2Fixture, point:V2, normal:V2, fraction:Number):void {
        trace(this, "onFraction", fixture, point, normal, fraction, fixture.m_body.m_userData);
        var s:Number = Box2DASRegistry.scale;
        _world.context.graphics.lineStyle(1, 0xFFFFFF, 1);
        var fx:Number = point.x * s;
        var fy:Number = point.y * s;
        drawCircle(_world.context.graphics, fx, fy, 2);
        //
    }
}
}

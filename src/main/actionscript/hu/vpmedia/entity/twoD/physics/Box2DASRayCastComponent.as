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

import hu.vpmedia.entity.core.BaseEntityComponent;
import hu.vpmedia.entity.twoD.physics.utils.Box2DASRegistry;

import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
public class Box2DASRayCastComponent extends BaseEntityComponent {
    private static const RAD_TO_DEG:Number = 180 / Math.PI; //57.29577951;

    private static const DEG_TO_RAD:Number = Math.PI / 180; //0.017453293;


    public var x:Number = 0;

    public var y:Number = 0;

    public var rotation:Number = 0;

    public var isBusy:Boolean;

    public var isDirty:Boolean = true;

    public var hasFound:Boolean;

    public var magnitude:Number = 1;

    public var totalMagnitude:Number = 0;

    public var maxMagniude:Number = 100;

    public var leftMagnitude:Number = 0;

    public var stepMagnitude:Number = 1;

    public var maxReflection:uint = 16;

    public var numReflection:uint = 0;

    public var startPoint:V2;

    public var endPoint:V2;

    public var foundFixture:b2Fixture;

    public var foundPoint:V2;

    public var foundNormal:V2;

    public var foundFraction:Number = 1;

    public var reflectionRotation:Number = 0;

    public var onRayCast:ISignal = new Signal(Box2DASRayCastComponent);

    public function Box2DASRayCastComponent(parameters:Object = null) {
        super(parameters);
    }

    public function doRayCast(v1:V2, v2:V2):void {
        foundFraction = 1;
        isBusy = true;
        hasFound = false;
        startPoint = new V2(v1.x, v1.y);
        endPoint = new V2(v2.x, v2.y);
        Box2DASRegistry.world.RayCast(rayCastHandler, v1, v2);
        if (hasFound) {
            isDirty = false;
            numReflection++;
            onRayCast.dispatch(this);
        }
        else {
            foundPoint = endPoint.clone();
            onRayCast.dispatch(this);
        }
        //trace(this.toString(), "doRayCast");
    }

    protected function rayCastHandler(fixture:b2Fixture, point:V2, normal:V2, fraction:Number):Number {
        isBusy = false;
        if (fixture.IsSensor()) {
            return -1;
        }
        //fixture.m_body.m_flags
        if (fraction == 1 || fraction == 0) {
            return -1;
        }
        if (fraction < foundFraction) {
            foundFixture = fixture;
            foundPoint = point.clone();
            foundNormal = normal.clone();
            foundFraction = fraction;
            var foundLength:Number = startPoint.distance(foundPoint);
            leftMagnitude -= foundLength;
            if (leftMagnitude < 0) {
                leftMagnitude = 0;
            }
            totalMagnitude += foundLength;
            // source plus normal
            //var normalEnd:V2 = point.clone().add(normal);
            var remainingRay:V2 = endPoint.clone().subtract(point);
            var dot:Number = remainingRay.dot(normal);
            var projectedOntoNormal:V2 = new V2(dot * 2 * normal.x, dot * 2 * normal.y);
            var nextEnd:V2 = endPoint.clone().subtract(projectedOntoNormal);
            // reflection
            reflectionRotation = Math.atan2(nextEnd.y - point.y, nextEnd.x - point.x) * RAD_TO_DEG;
            // continue path
            //reflectionRotation = _rotation * RAD_TO_DEG;
            // retraction - TODO
            //reflectionRotation = _rotation * ret * RAD_TO_DEG;
        }
        hasFound = true;
        //trace(this.toString(), "rayCastHandler", fixture.m_body.m_userData);
        return fraction;
    }

    public function dispose():void {
        //trace(this, "dispose");
        onRayCast.removeAll();
    }

    public function next():void {
        trace(this, "next");
        x = foundPoint.x * Box2DASRegistry.scale;
        y = foundPoint.y * Box2DASRegistry.scale;
        rotation = reflectionRotation;
        updateMagnitude();
        isBusy = false;
        isDirty = true;
        //trace(this.toString(), "next");
    }

    public function reset():void {
        startPoint = null;
        endPoint = null;
        foundFixture = null;
        foundPoint = null;
        foundNormal = null;
        foundFraction = 1;
        reflectionRotation = 0;
        numReflection = 0;
        leftMagnitude = totalMagnitude;
        totalMagnitude = 0;
        updateMagnitude();
        //trace(this.toString(), "reset");
    }

    protected function updateMagnitude():void {
        if (leftMagnitude > 0) {
            magnitude = leftMagnitude;
        }
        else {
            magnitude = 1;
        }
        //trace(this.toString(), "updateMagnitude");
    }

    public function toString():String {
        return "[Laser {magnitude:" + magnitude + ", totalMagnitude: " + totalMagnitude + ", leftMagnitude: " + leftMagnitude + ", isBusy: " + isBusy + ", isDirty: " + isDirty + ", hasFound: " + hasFound + "}]";
    }
}
}

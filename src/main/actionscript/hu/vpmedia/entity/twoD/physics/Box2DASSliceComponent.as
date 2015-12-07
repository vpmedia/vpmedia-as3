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
public class Box2DASSliceComponent extends BaseEntityComponent {
    public var x:Number = 0;

    public var y:Number = 0;

    public var rotation:Number = 0;

    public var isBusy:Boolean;

    public var magnitude:Number = 100;

    public var leftMagnitude:Number = 0;

    public var stepMagnitude:Number = 1;

    public var startPoint:V2;

    public var endPoint:V2;

    public var foundFixture:b2Fixture;

    public var foundPoint:V2;

    public var foundNormal:V2;

    public var foundFraction:Number = 1;

    public var onSliceCast:ISignal;

    public var onFraction:ISignal;

    public var isOpposite:Boolean;

    public function Box2DASSliceComponent(parameters:Object = null) {
        super(parameters);
        initialize();
    }

    protected function initialize():void {
        onSliceCast = new Signal(Box2DASSliceComponent);
        onFraction = new Signal(b2Fixture, V2, V2, Number);
    }

    public function doRayCast(v1:V2, v2:V2):void {
        trace("doRayCast", v1, v2);
        foundFraction = 1;
        isBusy = true;
        startPoint = new V2(v1.x, v1.y);
        endPoint = new V2(v2.x, v2.y);
        Box2DASRegistry.world.RayCast(rayCastHandler, v1, v2);
        if (isOpposite) {
            onSliceCast.dispatch(this);
        }
        else {
            onSliceCast.dispatch(this);
            isOpposite = true;
            doRayCast(endPoint, startPoint);
        }
    }

    protected function rayCastHandler(fixture:b2Fixture, point:V2, normal:V2, fraction:Number):Number {
        //isBusy=false;
        //fixture.m_body.m_flags
        if (fraction == 1 || fraction == 0) {
            return -1;
        }
        if (fraction < foundFraction && !isOpposite) {
            foundFixture = fixture;
            foundPoint = point.clone();
            foundNormal = normal.clone();
            foundFraction = fraction;
            var foundLength:Number = startPoint.distance(foundPoint);
            leftMagnitude -= foundLength;
            if (leftMagnitude < 0) {
                leftMagnitude = 0;
            }
            // source plus normal
            //var normalEnd:V2 = point.clone().add(normal);
            var remainingRay:V2 = endPoint.clone().subtract(point);
            var dot:Number = remainingRay.dot(normal);
            var projectedOntoNormal:V2 = new V2(dot * 2 * normal.x, dot * 2 * normal.y);
            var nextEnd:V2 = endPoint.clone().subtract(projectedOntoNormal);
        }
        onFraction.dispatch(fixture, point, normal, fraction);
        //trace(this.toString(), "rayCastHandler", fixture.m_body.m_userData);
        // return fraction; // nearest fraction
        return 1; // all fraction
    }

    public function dispose():void {
        //trace(this, "dispose");
        onSliceCast.removeAll();
        reset();
    }

    //----------------------------------
    //  API
    //----------------------------------
    public function reset():void {
        //trace(this.toString(), "reset");
        startPoint = null;
        endPoint = null;
        foundFixture = null;
        foundPoint = null;
        foundNormal = null;
        foundFraction = 1;
        isOpposite = false;
        isBusy = false;
    }

    public function toString():String {
        return "[Laser {startPoint: " + startPoint + ", endPoint: " + endPoint + ", foundPoint: " + foundPoint + ", isBusy: " + isBusy + ", isOpposite: " + isOpposite + "}]";
    }
}
}

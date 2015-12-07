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
package hu.vpmedia.entity.twoD.ai {
import flash.geom.Rectangle;

import hu.vpmedia.entity.core.BaseEntityComponent;
import hu.vpmedia.math.Vector2D;

/**
 * TBD
 * @see com.lookbackon.AI.steeringBehavior.*
 */
public class BoidComponent extends BaseEntityComponent {
    public var edgeBehavior:uint = EDGE_WRAP;
    public var mass:Number = 1.0;
    public var maxSpeed:Number = 10;
    public var position:Vector2D;
    public var velocity:Vector2D;
    public var bounds:Rectangle;
    // potential edge behaviors
    public static const EDGE_NONE:uint = 0;
    public static const EDGE_WRAP:uint = 1;
    public static const EDGE_BOUNCE:uint = 2;
    // steering
    public var maxForce:Number = 1;
    public var steeringForce:Vector2D;
    public var arrivalThreshold:Number = 100;
    public var wanderAngle:Number = 0;
    public var wanderDistance:Number = 10;
    public var wanderRadius:Number = 5;
    public var wanderRange:Number = 1;
    public var pathIndex:int = 0;
    public var pathThreshold:Number = 20;
    public var avoidDistance:Number = 300;
    public var avoidBuffer:Number = 20;
    public var inSightDist:Number = 200;
    public var tooCloseDist:Number = 60;

    public function BoidComponent(parameters:Object = null) {
        super(parameters);
    }

    override protected function setupDefaults():void {
        velocity = new Vector2D();
        position = new Vector2D();
        steeringForce = new Vector2D();
    }

    public function update():void {
        //
        // UPDATE STEERING
        //
        steeringForce.truncate(maxForce);
        steeringForce = steeringForce.divide(mass);
        velocity = velocity.add(steeringForce);
        steeringForce = new Vector2D();
        //
        // UPDATE VEHICLE
        //
        // make sure velocity stays within max speed.
        velocity.truncate(maxSpeed);
        // add velocity to position
        position = position.add(velocity);
        // handle any edge behavior
        if (edgeBehavior == EDGE_WRAP) {
            wrap();
        }
        else if (edgeBehavior == EDGE_BOUNCE) {
            bounce();
        }
    }

    /**
     * Causes character to bounce off edge if edge is hit.
     */
    public function bounce():void {
        if (bounds != null) {
            if (position.x > bounds.width) {
                position.x = bounds.width;
                velocity.x *= -1;
            }
            else if (position.x < 0) {
                position.x = 0;
                velocity.x *= -1;
            }
            if (position.y > bounds.height) {
                position.y = bounds.height;
                velocity.y *= -1;
            }
            else if (position.y < 0) {
                position.y = 0;
                velocity.y *= -1;
            }
        }
    }

    /**
     * Causes character to wrap around to opposite edge if edge is hit.
     */
    public function wrap():void {
        if (bounds != null) {
            if (position.x > bounds.width)
                position.x = 0;
            if (position.x < 0)
                position.x = bounds.width;
            if (position.y > bounds.height)
                position.y = 0;
            if (position.y < 0)
                position.y = bounds.height;
        }
    }

    // steering
    public function seek(target:Vector2D):void {
        var desiredVelocity:Vector2D = target.subtract(position);
        desiredVelocity.normalize();
        desiredVelocity = desiredVelocity.multiply(maxSpeed);
        var force:Vector2D = desiredVelocity.subtract(velocity);
        steeringForce = steeringForce.add(force);
    }

    public function flee(target:Vector2D):void {
        var desiredVelocity:Vector2D = target.subtract(position);
        desiredVelocity.normalize();
        desiredVelocity = desiredVelocity.multiply(maxSpeed);
        var force:Vector2D = desiredVelocity.subtract(velocity);
        steeringForce = steeringForce.subtract(force);
    }

    public function arrive(target:Vector2D):void {
        var desiredVelocity:Vector2D = target.subtract(position);
        desiredVelocity.normalize();
        var dist:Number = position.distance(target);
        if (dist > arrivalThreshold) {
            desiredVelocity = desiredVelocity.multiply(maxSpeed);
        }
        else {
            desiredVelocity = desiredVelocity.multiply(maxSpeed * dist / arrivalThreshold);
        }
        var force:Vector2D = desiredVelocity.subtract(velocity);
        steeringForce = steeringForce.add(force);
    }

    public function pursue(target:BoidComponent):void {
        var lookAheadTime:Number = position.distance(target.position) / maxSpeed;
        var predictedTarget:Vector2D = target.position.add(target.velocity.multiply(lookAheadTime));
        seek(predictedTarget);
    }

    public function evade(target:BoidComponent):void {
        var lookAheadTime:Number = position.distance(target.position) / maxSpeed;
        var predictedTarget:Vector2D = target.position.subtract(target.velocity.multiply(lookAheadTime));
        flee(predictedTarget);
    }

    public function wander():void {
        var center:Vector2D = velocity.clone().normalize().multiply(wanderDistance);
        var offset:Vector2D = new Vector2D(0);
        offset.length = wanderRadius;
        offset.angle = wanderAngle;
        wanderAngle += Math.random() * wanderRange - wanderRange * .5;
        var force:Vector2D = center.add(offset);
        steeringForce = steeringForce.add(force);
    }

    /* public function avoid(circles:Array):void
     {
     for (var i:int=0; i < circles.length; i++)
     {
     var circle:Circle=circles[i] as Circle;
     var heading:Vector2D=velocity.clone().normalize();
     // vector between circle and vehicle:
     var difference:Vector2D=circle.position.subtract(position);
     var dotProd:Number=difference.dotProd(heading);
     // if circle is in front of vehicle...
     if (dotProd > 0)
     {
     // vector to represent "feeler" arm
     var feeler:Vector2D=heading.multiply(avoidDistance);
     // project difference vector onto feeler
     var projection:Vector2D=heading.multiply(dotProd);
     // distance from circle to feeler
     var dist:Number=projection.subtract(difference).length;
     // if feeler intersects circle (plus buffer),
     //and projection is less than feeler length,
     // we will collide, so need to steer
     if (dist < circle.radius + avoidBuffer && projection.length < feeler.length)
     {
     // calculate a force +/- 90 degrees from vector to circle
     var force:Vector2D=heading.multiply(maxSpeed);
     force.angle+=difference.sign(velocity) * Math.PI / 2;
     // scale this force by distance to circle.
     // the further away, the smaller the force
     force=force.multiply(1.0 - projection.length / feeler.length);
     // add to steering force
     steeringForce=steeringForce.add(force);
     // braking force
     velocity=velocity.multiply(projection.length / feeler.length);
     }
     }
     }
     }*/ //TODO
    public function followPath(path:Array, loop:Boolean = false):void {
        var wayPoint:Vector2D = path[pathIndex];
        if (wayPoint == null)
            return;
        if (position.distance(wayPoint) < pathThreshold) {
            if (pathIndex >= path.length - 1) {
                if (loop) {
                    pathIndex = 0;
                }
            }
            else {
                pathIndex++;
            }
        }
        if (pathIndex >= path.length - 1 && !loop) {
            arrive(wayPoint);
        }
        else {
            seek(wayPoint);
        }
    }

    public function flock(vehicles:Array):void {
        var averageVelocity:Vector2D = velocity.clone();
        var averagePosition:Vector2D = new Vector2D();
        var inSightCount:int = 0;
        for (var i:int = 0; i < vehicles.length; i++) {
            var vehicle:BoidComponent = vehicles[i] as BoidComponent;
            if (vehicle != this && inSight(vehicle)) {
                averageVelocity = averageVelocity.add(vehicle.velocity);
                averagePosition = averagePosition.add(vehicle.position);
                if (tooClose(vehicle))
                    flee(vehicle.position);
                inSightCount++;
            }
        }
        if (inSightCount > 0) {
            averageVelocity = averageVelocity.divide(inSightCount);
            averagePosition = averagePosition.divide(inSightCount);
            seek(averagePosition);
            steeringForce.add(averageVelocity.subtract(velocity));
        }
    }

    public function inSight(vehicle:BoidComponent):Boolean {
        if (position.distance(vehicle.position) > inSightDist)
            return false;
        var heading:Vector2D = velocity.clone().normalize();
        var difference:Vector2D = vehicle.position.subtract(position);
        var dotProd:Number = difference.dotProduct(heading);
        if (dotProd < 0)
            return false;
        return true;
    }

    public function tooClose(vehicle:BoidComponent):Boolean {
        return position.distance(vehicle.position) < tooCloseDist;
    }
}
}

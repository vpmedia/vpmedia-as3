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
 * @author Andras Csizmadia
 * @version 1.0
 * @see http://rocketmandevelopment.com/series/steering-behaviors/
 */
public class SteeringComponent extends BaseEntityComponent {
    public var edgeBehavior:uint;

    public var velocity:Vector2D;

    public var position:Vector2D;

    public var rotation:Number;

    public var mass:Number;

    public var maxSpeed:Number;

    public var maxForce:Number;

    public var inSightDist:int;

    public var checkLength:Number; //the distance to look ahead for circles

    public var radius:int; //the radius of the circle

    public var index:int; //the current waypoint index in the path array

    public var slowingDistance:Number; //slowing distance, you can adjust this

    public var wanderAngle:Number; //the change to the current direction. Produces sustained turned, keeps it from being jerky. Makes it smooth

    public var wanderChange:Number; //the amount to change the angle each frame.

    public var bounds:Rectangle;

    // potential edge behaviors
    public static const EDGE_NONE:uint = 0;

    public static const EDGE_WRAP:uint = 1;

    public static const EDGE_BOUNCE:uint = 2;

    public function SteeringComponent(parameters:Object = null) {
        super(parameters);
    }

    override protected function setupDefaults():void {
        radius = 6;
        index = 0;
        wanderAngle = 0;
        wanderChange = 1;
        slowingDistance = 20
        checkLength = 100;
        inSightDist = 25;
        edgeBehavior = EDGE_WRAP;
        velocity = new Vector2D();
        position = new Vector2D();
        rotation = 0;
        mass = 2;
        maxSpeed = 2;
        maxForce = 2;
    }

    public function update():void {
        // keep it witin its max speed
        velocity.truncate(maxSpeed);
        // move it
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

    public function arrive(target:Vector2D):void {
        var desiredVelocity:Vector2D = target.clone().subtract(position).normalize(); //find the straight path and normalize it
        var distance:Number = position.distance(target); //find the distance
        if (distance > slowingDistance) { //if its still too far away
            desiredVelocity.multiply(maxSpeed); //go at full speed
        }
        else {
            desiredVelocity.multiply(maxSpeed * distance / slowingDistance); //if not, slow down
        }
        var force:Vector2D = desiredVelocity.subtract(velocity).truncate(maxForce); //keep the force within the max
        velocity.add(force); //apply the force
    }

    public function avoidObstacles(circles:Vector.<SteeringComponent>):void {
        for (var i:int = 0; i < circles.length; i++) { //loop through the array of obstacles
            var forward:Vector2D = velocity.clone().normalize(); //get the forward vector
            var diff:Vector2D = circles[i].position.clone().subtract(position); //get the difference between the circle and the target
            var dotProd:Number = diff.dotProduct(forward); //get the dot product
            //this will be used for projection
            if (dotProd > 0) { //if this object is in front of the target
                var ray:Vector2D = forward.clone().multiply(checkLength); //get the ray
                var projection:Vector2D = forward.clone().multiply(dotProd); //project the forward vector
                var dist:Number = projection.clone().subtract(diff).length; //get the distance between the circle and target
                // radius WAS NUMBER!!!
                if (dist < circles[i].radius + radius && projection.length < ray.length) {
                    //if the circle is in your path (radius+width to check the full size of the target)
                    //projection.length and ray.length make sure you are within the max distance
                    var force:Vector2D = forward.clone().multiply(maxSpeed); //get the max force
                    force.angle += diff.sign(velocity) * Math.PI / 2; //rotate it away from the cirlce
                    //PI / 2 is 90 degrees, vector's angles are in radians
                    //sign returns whether the vector is to the right or left of the other vector
                    force.multiply(1 - projection.length / ray.length); //scale the force so that a far off object
                    //doesn't drastically change the velocity
                    velocity.add(force); //change the velocity
                    velocity.multiply(projection.length / ray.length); //and scale again
                }
            }
        }
    }

    public function evade(target:SteeringComponent):void {
        var distance:Number = target.position.distance(position);
        var T:Number = distance / target.maxSpeed;
        var targetPosition:Vector2D = target.position.clone().add(target.velocity.clone().multiply(T));
        flee(targetPosition);
    }

    public function flee(target:Vector2D):void {
        var desiredVelocity:Vector2D = target.clone().subtract(position).normalize().multiply(maxSpeed);
        var steeringForce:Vector2D = desiredVelocity.subtract(velocity);
        velocity.add(steeringForce.divide(mass).multiply(-1).truncate(maxForce));
    }

    public function flock(targets:Vector.<SteeringComponent>):void {
        var averageVelocity:Vector2D = velocity.clone(); // used for alignment.
        //starting with the current targets velocity keeps the targets from stopping
        var averagePosition:Vector2D = new Vector2D(); //used for cohesion
        var counter:int = 0; //used for cohesion
        for (var i:int = 0; i < targets.length; i++) { //for each target
            var target:SteeringComponent = targets[i];
            if (target != this && isInSight(target)) { //if it is not the current target
                //and it is in sight
                averageVelocity.add(target.velocity); //add its velocity to the average velocity
                averagePosition.add(target.position); //add its position to the average position
                if (isTooClose(target)) { //if it is too close
                    flee(target.position); //flee it, this is separation
                }
                counter++; //increase the counter to use for finding the average
            }
        }
        if (counter > 0) { //if there are targets around
            averageVelocity.divide(counter); //divide to find average
            averagePosition.divide(counter); //divide to find average
            seek(averagePosition); //seek the average, this is cohesion
            velocity.add(averageVelocity.subtract(velocity).divide(mass).truncate(maxForce));
            //add the average velocity to the velocity after adjusting the force
            //this is alignment
        }
    }

    public function flowField(field:Array):void {
        var fieldX:int = Math.floor(position.x / 50); //find the targets location in the field
        var fieldY:int = Math.floor(position.y / 50);
        if (fieldX < 0 || fieldY < 0 || fieldX > field.length || fieldY > field[0].length) {
            //this is the important part. If the target is not in the field, we do nothing
            //if the x or y is less than 0, it isn't on the field
            //if the x or y is greater than the length of the array(size of the field), you are not in the field
            return;
        }
        var force:Vector2D = field[fieldX][fieldY].clone(); //clone the vector so we don't change it
        velocity.add(force.divide(mass).truncate(maxForce)); //apply the vector based on mass and within the max force.
    }

    public function followLeader(leader:SteeringComponent, targets:Vector.<SteeringComponent>):void {
        //each follower is given an array of all the other targets and the leader
        var leaderPos:Vector2D = leader.position.clone(); //get the leaders position
        //clone it so you can modify it
        if (leader.inSight(this)) { //if the leader can see you
            var dist:Number = leaderPos.distance(position); //check the distance
            if (dist < 50) { //if you are within 50px
                seek(leaderPos.add(leader.velocity.perpendicular)); //move away from where the leader is going
                return; //stop following
            }
        }
        //if you are not in the leaders way
        leaderPos.subtract(leader.velocity.clone().normalize().multiply(10)); //get a point behind the leader
        arrive(leaderPos); //arrive at it
        //separation for all other targets
        for (var i:int = 0; i < targets.length; i++) {
            var target:SteeringComponent = targets[i];
            if (tooClose(target)) {
                flee(target.position);
            }
        }
    }

    public function followPath(path:Array):void {
        if (index >= path.length) { //if you have finished with the path
            velocity.multiply(0.9); //slow down
            return; //quit
        } //otherwise
        var waypoint:Vector2D = path[index]; //get the current waypoint
        var dist:Number = waypoint.distance(position); //get the distance from the waypoint
        if (dist < 10) { //if you are within 10 pixels of the waypoint(can be adjusted based on your needs)
            index++; //go to the next waypoint
            return; //quit for now
        }
        seek(waypoint); //otherwise, seek the current waypoint
    }

    public function inSight(target:SteeringComponent):Boolean {
        if (position.distance(target.position) > inSightDist) {
            return false;
        }
        var heading:Vector2D = velocity.clone().normalize();
        var difference:Vector2D = target.position.clone().subtract(position);
        var dotProd:Number = difference.dotProduct(heading);
        if (dotProd < 0) {
            return false;
        }
        return true;
    }

    public function isInSight(target:SteeringComponent):Boolean {
        if (position.distance(target.position) > 120) { //this is changed based on the desired flocking style
            return false; //you are too far away, do nothing
        }
        var direction:Vector2D = velocity.clone().normalize(); //get the direction
        var difference:Vector2D = target.position.clone().subtract(position); //find the difference of the two positions
        var dotProd:Number = difference.dotProduct(direction); //dotProduct
        if (dotProd < 0) {
            return false; //you are too far away and not facing the right direction
        }
        return true; //you are in sight.
    }

    public function isTooClose(target:SteeringComponent):Boolean {
        return position.distance(target.position) < 80;
    }

    public function pursuit(target:SteeringComponent):void {
        var distance:Number = target.position.distance(position);
        var T:Number = distance / target.maxSpeed;
        var targetPosition:Vector2D = target.position.clone().add(target.velocity.clone().multiply(T));
        seek(targetPosition);
    }

    public function seek(target:Vector2D):void {
        var desiredVelocity:Vector2D = target.clone().subtract(position).normalize().multiply(maxSpeed);
        var steeringForce:Vector2D = desiredVelocity.subtract(velocity);
        velocity.add(steeringForce.divide(mass).truncate(maxForce));
    }

    public function tooClose(target:SteeringComponent):Boolean {
        return position.distance(target.position) < 50;
    }

    public function unalignedAvoidance(targets:Vector.<SteeringComponent>):void {
        for (var i:int = 0; i < targets.length; i++) { //check each target
            var forward:Vector2D = velocity.clone().normalize(); //get the forward vector
            var diff:Vector2D = targets[i].position.clone().add(targets[i].velocity.clone().normalize().multiply(checkLength)).subtract(position);
            var dotProd:Number = diff.dotProduct(forward); //dot product between forward and difference
            if (dotProd > 0) { //they may meet in the future
                var ray:Vector2D = forward.clone().multiply(checkLength); //cast a ray in the forward direction
                var projection:Vector2D = forward.clone().multiply(dotProd); //project the forward vector
                var dist:Number = projection.clone().subtract(diff).length; //get the distance
                // radius WAS NUMBER!!!
                if (dist < targets[i].radius + radius && projection.length < ray.length) { //they will meet in the future, we need to fix it
                    var force:Vector2D = forward.clone().multiply(maxSpeed); //get the maximum change
                    force.angle += diff.sign(velocity) * Math.PI / 4; //rotate it away from the site of the collision
                    force.multiply(1 - projection.length / ray.length); //scale it based on the distance between the position and collision site
                    velocity.add(force); //adjust the velocity
                    velocity.multiply(projection.length / ray.length); //scale the velocity
                }
            }
        }
    }

    //Those numbers can be changed to get other movement patterns. Those are the defaults used in the demo
    public function wander():void {
        var circleMidde:Vector2D = velocity.clone().normalize().multiply(radius); //circle middle is the the velocity pushed out to the radius.
        var wanderForce:Vector2D = new Vector2D();
        wanderForce.length = 3; //force length, can be changed to get a different motion
        wanderForce.angle = wanderAngle; //set the angle to move
        wanderAngle += Math.random() * wanderChange - wanderChange * .5; //change the angle randomly to make it wander
        var force:Vector2D = circleMidde.add(wanderForce); //apply the force
        velocity.add(force); //then update
    }
}
}

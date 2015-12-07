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
package hu.vpmedia.entity.twoD.physics.utils {
import Box2DAS.Collision.Shapes.b2PolygonShape;
import Box2DAS.Common.V2;
import Box2DAS.Dynamics.b2Body;
import Box2DAS.Dynamics.b2Fixture;

// idea by Box2D body slicer, created by Antoan Angelov.
public class Box2DASSliceUtil {
    public function Box2DASSliceUtil() {
    }

    public static function splitObj(sliceBody:b2Body, A:V2, B:V2):void {
        var origFixture:b2Fixture = sliceBody.GetFixtureList();
        var poly:b2PolygonShape = origFixture.GetShape() as b2PolygonShape;
        var verticesVec:Vector.<V2> = poly.m_vertices, numVertices:int = poly.GetVertexCount();
        var shape1Vertices:Vector.<V2> = new Vector.<V2>(), shape2Vertices:Vector.<V2> = new Vector.<V2>();
        // #! var origUserData:userData=sliceBody.GetUserData(), origUserDataId:int=origUserData.id, d:Number;
        // First, I destroy the original body and remove its Sprite representation from the childlist.
        Box2DASRegistry.world.DestroyBody(sliceBody);
        //objectsCont.removeChild(origUserData);
        // The world.RayCast() method returns points in world coordinates, so I use the b2Body.GetLocalPoint() to convert them to local coordinates.
        A = sliceBody.GetLocalPoint(A);
        B = sliceBody.GetLocalPoint(B);
        // I use shape1Vertices and shape2Vertices to store the vertices of the two new shapes that are about to be created.
        // Since both point A and B are vertices of the two new shapes, I add them to both vectors.
        shape1Vertices.push(A, B);
        shape2Vertices.push(A, B);
        // I iterate over all vertices of the original body.
        // I use the function det() ("det" stands for "determinant") to see on which side of AB each point is standing on. The parameters it needs are the coordinates of 3 points:
        // - if it returns a value >0, then the three points are in clockwise order (the point is under AB)
        // - if it returns a value =0, then the three points lie on the same line (the point is on AB)
        // - if it returns a value <0, then the three points are in counter-clockwise order (the point is above AB).
        var i:int;
        var d:Number;
        for (i = 0; i < numVertices; i++) {
            d = det(A.x, A.y, B.x, B.y, verticesVec[i].x, verticesVec[i].y);
            if (d > 0)
                shape1Vertices.push(verticesVec[i]);
            else
                shape2Vertices.push(verticesVec[i]);
        }
        // In order to be able to create the two new shapes, I need to have the vertices arranged in clockwise order.
        // I call my custom method, arrangeClockwise(), which takes as a parameter a vector, representing the coordinates of the shape's vertices and returns a new vector, with the same points arranged clockwise.
        shape1Vertices = arrangeClockwise(shape1Vertices);
        shape2Vertices = arrangeClockwise(shape2Vertices);
        // setting the properties of the two newly created shapes
        /*bodyDef=new b2BodyDef();
         bodyDef.type=b2Body.b2_dynamicBody;
         bodyDef.position.SetV(sliceBody.GetPosition());
         fixtureDef=new b2FixtureDef();
         fixtureDef.density=origFixture.GetDensity();
         fixtureDef.friction=origFixture.GetFriction();
         fixtureDef.restitution=origFixture.GetRestitution();
         // creating the first shape
         polyShape=new b2PolygonShape();
         polyShape.SetAsVector(shape1Vertices);
         fixtureDef.shape=polyShape;
         bodyDef.userData=new userData(origUserDataId, shape1Vertices, origUserData.texture);
         objectsCont.addChild(bodyDef.userData);
         enterPointsVec[origUserDataId]=null;
         body=world.CreateBody(bodyDef);
         body.SetAngle(sliceBody.GetAngle());
         body.CreateFixture(fixtureDef);
         body.SetBullet(true);
         // creating the second shape
         polyShape=new b2PolygonShape();
         polyShape.SetAsVector(shape2Vertices);
         fixtureDef.shape=polyShape;
         bodyDef.userData=new userData(numEnterPoints, shape2Vertices, origUserData.texture);
         objectsCont.addChild(bodyDef.userData);
         enterPointsVec.push(null);
         numEnterPoints++;
         body=world.CreateBody(bodyDef);
         body.SetAngle(sliceBody.GetAngle());
         body.CreateFixture(fixtureDef);
         body.SetBullet(true);*/
    }

    public static function arrangeClockwise(vec:Vector.<V2>):Vector.<V2> {
        // The algorithm is simple:
        // First, it arranges all given points in ascending order, according to their x-coordinate.
        // Secondly, it takes the leftmost and rightmost points (lets call them C and D), and creates tempVec, where the points arranged in clockwise order will be stored.
        // Then, it iterates over the vertices vector, and uses the det() method I talked about earlier. It starts putting the points above CD from the beginning of the vector, and the points below CD from the end of the vector.
        // That was it!
        var n:int = vec.length;
        var d:Number;
        var i1:int = 1;
        var i2:int = n - 1;
        var tempVec:Vector.<V2> = new Vector.<V2>(n), C:V2, D:V2;
        vec.sort(comp1);
        tempVec[0] = vec[0];
        C = vec[0];
        D = vec[n - 1];
        var i:int;
        for (i = 1; i < n - 1; i++) {
            d = det(C.x, C.y, D.x, D.y, vec[i].x, vec[i].y);
            if (d < 0)
                tempVec[i1++] = vec[i];
            else
                tempVec[i2--] = vec[i];
        }
        tempVec[i1] = vec[n - 1];
        return tempVec;
    }

    public static function comp1(a:V2, b:V2):Number {
        // This is a compare function, used in the arrangeClockwise() method - a fast way to arrange the points in ascending order, according to their x-coordinate.
        if (a.x > b.x)
            return 1;
        else if (a.x < b.x)
            return -1;
        return 0;
    }

    public static function det(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number):Number {
        // This is a function which finds the determinant of a 3x3 matrix.
        // If you studied matrices, you'd know that it returns a positive number if three given points are in clockwise order, negative if they are in anti-clockwise order and zero if they lie on the same line.
        // Another useful thing about determinants is that their absolute value is two times the face of the triangle, formed by the three given points.
        return x1 * y2 + x2 * y3 + x3 * y1 - y1 * x2 - y2 * x3 - y3 * x1;
    }
}
}

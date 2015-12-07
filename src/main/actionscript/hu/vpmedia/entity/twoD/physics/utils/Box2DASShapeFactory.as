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
import Box2DAS.Common.b2Def;
import Box2DAS.Dynamics.b2Fixture;

import flash.geom.Point;

import hu.vpmedia.entity.twoD.physics.Box2DASPhysicsComponent;

/**
 * @author Andras Csizmadia
 * @version 1.0
 */
public class Box2DASShapeFactory {
    private static const RAD_TO_DEG:Number = 180 / Math.PI; //57.29577951;

    private static const DEG_TO_RAD:Number = Math.PI / 180; //0.017453293;

    public function Box2DASShapeFactory() {
    }

    public static function box(target:Box2DASPhysicsComponent, w:Number, h:Number, pos:V2 = null, angle:Number = 0):b2Fixture {
        pos ||= new V2();
        var halfWidth:Number = w / 2;
        var halfHeight:Number = h / 2;
        var vertices:Vector.<V2> = Vector.<V2>([ new V2(-halfWidth, -halfHeight), new V2(halfWidth, -halfHeight), new V2(halfWidth, halfHeight), new V2(-halfWidth, halfHeight)]);
        orientVertices(vertices, pos, angle);
        return polygon(target, vertices);
    }

    /**
     * Define a circle. If you don't pass a radius, it'll guess one from the width. Note: Skew transforms wont work, neither will non-uniform XY
     * scaling (an oval shape).
     */
    public static function circle(target:Box2DASPhysicsComponent, radius:Number = 0, pos:V2 = null):b2Fixture {
        pos ||= new V2();
        var v1:V2 = pos.clone();
        var v:Vector.<V2> = Vector.<V2>([ v1, new V2(v1.x + radius, v1.y)]);
        transformVertices(v);
        b2Def.circle.m_radius = v[0].distance(v[1]);
        //trace(v[0].x, v[0].y);
        b2Def.circle.m_p.x = v[0].x;
        b2Def.circle.m_p.y = v[0].y;
        defineFixture(target);
        b2Def.fixture.shape = b2Def.circle;
        return createFixture(target);
    }

    /**
     * Define a stretchable circle.
     */
    public static function oval(target:Box2DASPhysicsComponent, width:Number = 0, height:Number = 0, pos:V2 = null, sides:uint = 0, detail:Number = 4, angle:Number = 0):Array {
        pos ||= new V2();
        var w2:Number = width / 2;
        var h2:Number = height / 2;
        /// TO DO: better way to detect circle shape?
        var p1:Point = new Point(w2, 0);
        var p2:Point = new Point(0, h2);
        var p3:Point = new Point(0, 0);
        var d1:Number = Point.distance(p1, p3);
        var d2:Number = Point.distance(p2, p3);
        var a:Number = Math.abs(d1 - d2);
        if (a < 2) { // Tolerance to snap to circle.
            return [ circle(target, w2, pos)];
        }
        if (sides == 0) {
            var d:Number = Point.distance(p1, p2);
            sides = Math.round(d / Box2DASRegistry.scale * detail);
        }
        var polys:Array = [];
        sides = Math.max(sides, 12);
        for (var i:uint = 1; i < sides; i += 6) {
            var v:Vector.<V2> = Vector.<V2>([ new V2(w2, 0)]);
            var j2:uint = Math.min(i + 6, sides - 1);
            for (var j:uint = i; j <= j2; ++j) {
                var rad:Number = j / sides * Math.PI * 2;
                v.push(new V2(w2 * Math.cos(rad), h2 * Math.sin(rad)));
            }
            orientVertices(v, pos, angle);
            polys.push(polygon(target, v));
        }
        return polys;
    }

    /**
     * Define a polygon with a variable number of sides.
     */
    public static function polyN(target:Box2DASPhysicsComponent, sides:uint = 5, radius:Number = 0, pos:V2 = null, angle:Number = 0):b2Fixture {
        pos ||= new V2();
        var vertices:Vector.<V2> = new Vector.<V2>();
        for (var i:uint = 0; i < sides; ++i) {
            vertices.push(new V2(0, radius).rotate(i / sides * Math.PI * 2));
        }
        orientVertices(vertices, pos, angle);
        return polygon(target, vertices);
    }

    /**
     * Creates a solid semi circle.
     */
    public static function arc(target:Box2DASPhysicsComponent, degrees:Number = 360, sides:uint = 0, radius:Number = 0, pos:V2 = null, angle:Number = 0, detail:Number = 4):Array {
        pos ||= new V2();
        sides = Math.max(sides, 12); // Arbitrary minimum - but since <0,0> is part of every poly, forces them to be convex.
        var rad:Number = DEG_TO_RAD * degrees;
        var polys:Array = [];
        for (var i:uint = 0; i < sides; i += 4) {
            var v:Vector.<V2> = Vector.<V2>([ new V2()]);
            var j2:uint = Math.min(i + 4, sides);
            for (var j:uint = i; j <= j2; ++j) {
                v.push(new V2(0, radius).rotate(j / sides * rad));
            }
            orientVertices(v, pos, angle);
            polys.push(polygon(target, v));
        }
        return polys;
    }

    /**
     * Creates a solie semi circle using edges.
     */
    public static function edgeArc(target:Box2DASPhysicsComponent, degrees:Number = 360, sides:uint = 0, radius:Number = 0, pos:V2 = null, angle:Number = 0, detail:Number = 8):Array {
        pos ||= new V2();
        var rad:Number = DEG_TO_RAD * degrees;
        var v:Vector.<V2> = new Vector.<V2>();
        for (var i:uint = 0; i <= sides; ++i) {
            v.push(new V2(0, radius).rotate((i) / sides * rad));
        }
        orientVertices(v, pos, angle);
        return edges(target, v);
    }

    /**
     * Creates a solid semi circle using lines (two point polygons).
     */
    public static function lineArc(target:Box2DASPhysicsComponent, degrees:Number = 360, sides:uint = 0, radius:Number = 0, pos:V2 = null, angle:Number = 0, detail:Number = 8):Array {
        pos ||= new V2();
        var rad:Number = DEG_TO_RAD * degrees;
        var polys:Array = [];
        var v:Vector.<V2> = Vector.<V2>([ new V2(0, radius)]);
        for (var i:uint = 0; i < sides; ++i) {
            v[1] = new V2(0, radius).rotate((i + 1) / sides * rad);
            orientVertices(v, pos, angle);
            polys.push(line(target, v[0], v[1]));
            v[0].x = v[1].x;
            v[0].y = v[1].y;
        }
        return polys;
    }

    /**
     * A right triangle constructed in the same way as the "box" function but with the upper right vertex deleted.
     */
    public static function triangle(target:Box2DASPhysicsComponent, w:Number = 0, h:Number = 0, pos:V2 = null, angle:Number = 0):b2Fixture {
        pos ||= new V2();
        var halfWidth:Number = w / 2;
        var halfHeight:Number = h / 2;
        var vertices:Vector.<V2> = Vector.<V2>([ new V2(-halfWidth, -halfHeight), //new V2(halfWidth, -halfHeight),
            new V2(halfWidth, halfHeight), new V2(-halfWidth, halfHeight)]);
        orientVertices(vertices, pos, angle);
        return polygon(target, vertices);
    }

    /**
     * A single line from point 1 to 2 using a polygon.
     */
    public static function line(target:Box2DASPhysicsComponent, v1:V2 = null, v2:V2 = null):b2Fixture {
        return polygon(target, Vector.<V2>([ v1, v2 ]));
    }

    /**
     * A single edge shape.
     */
    public static function edge(target:Box2DASPhysicsComponent, v1:V2 = null, v2:V2 = null):b2Fixture {
        var e:Array = edges(target, Vector.<V2>([ v1, v2 ]));
        return e[0];
    }

    /**
     * Define a polygon. Pass in an array of vertices in [[x, y], [x, y], ...] format
     */
    public static function poly(target:Box2DASPhysicsComponent, vertices:Array):b2Fixture {
        var v:Vector.<V2> = new Vector.<V2>();
        for (var i:int = 0; i < vertices.length; ++i) {
            v.push(new V2(vertices[i][0], vertices[i][1]));
        }
        return polygon(target, v);
    }

    /**
     * Takes an array of polygon points - each is sent to the "poly" function.
     */
    public static function polys(target:Box2DASPhysicsComponent, vertices:Array):Array {
        var a:Array = [];
        for (var i:int = 0; i < vertices.length; ++i) {
            a.push(poly(target, vertices[i]));
        }
        return a;
    }

    /**
     *
     */
    public static function decomposedPoly(target:Box2DASPhysicsComponent, vertices:Vector.<Number>):Array {
        for (var i:int = 0; i < vertices.length; ++i) {
            vertices[i] /= Box2DASRegistry.scale;
        }
        var s:Vector.<b2PolygonShape> = b2PolygonShape.Decompose(vertices);
        defineFixture(target);
        var f:Array = [];
        for (i = 0; i < s.length; ++i) {
            b2Def.fixture.shape = s[i];
            f.push(createFixture(target));
            s[i].destroy();
        }
        return f;
    }

    public static function polygon(target:Box2DASPhysicsComponent, vertices:Vector.<V2>):b2Fixture {
        transformVertices(vertices);
        /// If the bodyshape has been flipped on its y or x axis, then vertices are in the wrong direction.
        b2PolygonShape.EnsureCorrectVertexDirection(vertices);
        b2Def.polygon.Set(vertices);
        defineFixture(target);
        b2Def.fixture.shape = b2Def.polygon;
        return createFixture(target);
    }

    public static function edges(target:Box2DASPhysicsComponent, vertices:Vector.<V2>):Array {
        transformVertices(vertices);
        defineFixture(target);
        b2Def.fixture.shape = b2Def.edge;
        var e:Array = [];
        for (var i:int = 1; i < vertices.length; ++i) {
            b2Def.edge.m_vertex1.v2 = vertices[i - 1];
            b2Def.edge.m_vertex2.v2 = vertices[i];
            b2Def.edge.m_hasVertex0 = i > 1;
            b2Def.edge.m_hasVertex3 = i + 1 < vertices.length;
            b2Def.edge.m_vertex0.v2 = b2Def.edge.m_hasVertex0 ? vertices[i - 2] : new V2();
            b2Def.edge.m_vertex3.v2 = b2Def.edge.m_hasVertex3 ? vertices[i + 1] : new V2();
            e.push(createFixture(target));
        }
        return e;
    }

    private static function defineFixture(target:Box2DASPhysicsComponent):void {
        b2Def.fixture.density = target.density;
        b2Def.fixture.friction = target.friction;
        b2Def.fixture.restitution = target.restitution;
        b2Def.fixture.isSensor = target.isSensor;
        b2Def.fixture.filter.categoryBits = target.categoryBits;
        b2Def.fixture.filter.maskBits = target.maskBits;
        b2Def.fixture.filter.groupIndex = target.groupIndex;
    }

    private static function createFixture(target:Box2DASPhysicsComponent):b2Fixture {
        var fixture:b2Fixture = target.getBody().CreateFixture(b2Def.fixture);
        target.getFixtures().push(fixture);
        fixture.m_reportBeginContact = target.reportBeginContact;
        fixture.m_reportEndContact = target.reportEndContact;
        fixture.m_reportPreSolve = target.reportPreSolve;
        fixture.m_reportPostSolve = target.reportPostSolve;
        fixture.m_conveyorBeltSpeed = target.conveyorBeltSpeed;
        fixture.m_bubbleContacts = target.bubbleContacts;
        //_fixtureSignalSet=new FixtureSignalSet(_fixture);
        return fixture;
    }

    /**
     * Takes a polygon (list of vertices) and rotates, repositions them.
     */
    private static function orientVertices(vertices:Vector.<V2>, pos:V2 = null, angle:Number = 0):void {
        pos ||= new V2();
        if (angle != 0 || pos.x != 0 || pos.y != 0) {
            for (var i:uint = 0; i < vertices.length; ++i) {
                vertices[i].rotate(DEG_TO_RAD * angle).add(pos);
            }
        }
    }

    /**
     * Takes an array of vertices ([[x,y],[x,y]]) and transforms them based on their MovieClip transformation.
     */
    private static function transformVertices(vertices:Vector.<V2>):void {
        for (var i:int = 0; i < vertices.length; ++i) {
            vertices[i] = transformVertex(vertices[i]);
        }
    }

    /**
     * Will take a flash X,Y within this object and return a new X,Y reflecting where that
     * X, Y is in Box2d dimentions.
     */
    private static function transformVertex(xy:V2):V2 {
        //var p:Point=matrix.transformPoint(xy.toP());
        var p:Point = xy.toP();
        return new V2(p.x / Box2DASRegistry.scale, p.y / Box2DASRegistry.scale);
    }
}
}

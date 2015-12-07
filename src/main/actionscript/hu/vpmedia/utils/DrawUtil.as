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
package hu.vpmedia.utils {
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;

import hu.vpmedia.errors.StaticClassError;

/**
 * Based on source code found at:
 * http://www.macromedia.com/devnet/mx/flash/articles/adv_draw_methods.html
 *
 * @author Ric Ewing - version 1.4 - 4.7.2002
 * @author Kevin Williams - version 2.0 - 4.7.2005
 * @author Aden Forshaw - Version AS3 - 19.4.2010
 * @author Sidney de Koning - Version AS3 - 20.4.2010 - errors/correct datatypes/optimized math operations
 * @author Andras Csizmadia
 *
 * Usage:
 * var s : Shape = new Shape( ); // Or Sprite of MovieClip or any other Class that makes use of the Graphics class
 *
 * // Draw an ARC
 * s.graphics.lineStyle( 4, 0xE16606 );
 * DrawUtil.drawArc( s.graphics, 50, 50, 10, 150, 60 );
 *
 * // Draw an BURST
 * s.graphics.lineStyle( 3, 0x000000 );
 * DrawUtil.drawBurst( s.graphics, 80, 60, 3, 15, 6, 27 );
 *
 * // Draw an DASHED-LINE like so - - - -
 * s.graphics.lineStyle( 1, 0x3C3C39 );
 * DrawUtil.drawDash( s.graphics, 120, 60, 150, 80, 2, 2 );
 *
 * // Draw an GEAR
 * s.graphics.lineStyle( 3, 0xE16606 );
 * DrawUtil.drawGear( s.graphics, 200, 60, 13, 31, 26, 0, 7, 13 );
 *
 * // Draw a POLYGON
 * s.graphics.lineStyle( 3, 0x0074B9 );
 * DrawUtil.drawPolygon( s.graphics, 270, 60, 7, 30, 45 );
 *
 * // Draw a STAR
 * s.graphics.lineStyle( 2, 0x000000 );
 * DrawUtil.drawStar( s.graphics, 340, 60, 18, 24, 19, 27 );
 *
 * // Draw an WEDGE - good for pie charts or pacmans
 * s.graphics.lineStyle( 2, 0xFFCC00 );
 * DrawUtil.drawWedge( s.graphics, 400, 60, 30, 309, 209 );
 *
 * // Draw a LINE
 * s.graphics.lineStyle( 2, 0x0074B9 );
 * DrawUtil.drawLine( s.graphics, 440, 85, 30, DrawUtil.VERTICAL_LINE );
 *
 * addChild( s );
 */
public final class DrawUtil {
    public static const HORIZONTAL_LINE:String = "DrawUtil.horizontal";

    public static const VERTICAL_LINE:String = "DrawUtil.vertical";

    public function DrawUtil():void {
        throw new StaticClassError();
    }

    public static function drawPixelIcon(graphics:Graphics, data:Array):void {
        var maxRows:int = data.length;
        var maxColumns:int;
        var row:int;
        var col:int;
        var size:int = 1;
        for (row = 0; row < maxRows; row++) {
            maxColumns = data[row].length;
            for (col = 0; col < maxColumns; col++) {
                if (String(data[row]).charAt(col) != " ") {
                    graphics.drawRect(col, row, size, size);
                }
            }
        }
    }

    public static function drawArrow(graphics:Graphics, start:Point, end:Point, curve:Point, style:Object = null):void {
        if (start.equals(end))
            return;
        var arrowStyle:ArrowStyle;
        if (style == null) {
            arrowStyle = new ArrowStyle();
        }
        else if (style is ArrowStyle) {
            arrowStyle = style as ArrowStyle;
        }
        else {
            arrowStyle = new ArrowStyle(style);
        }
        // if arrow will be bigger than line,
        // just draw the line
        var testDist:Point = end.subtract(start);
        if (testDist.length < arrowStyle.headLength) {
            graphics.lineStyle(arrowStyle.shaftThickness);
            graphics.moveTo(start.x, start.y);
            graphics.lineTo(end.x, end.y);
            return;
        }
        var fullVect:Point = end.subtract(start);
        var halfWidth:Number = (arrowStyle.headWidth != -1) ? arrowStyle.headWidth / 2 : arrowStyle.headLength / 2;
        //Figure out the line start/end points
        var startNorm:Point = new Point(fullVect.y, -fullVect.x);
        startNorm.normalize(arrowStyle.shaftThickness / 2);
        var start1:Point = start.add(startNorm);
        var start2:Point = start.subtract(startNorm);
        var curve1:Point = curve.add(startNorm);
        var curve2:Point = curve.subtract(startNorm);
        var endFullVect:Point = end.subtract(curve);
        var endNorm:Point = new Point(endFullVect.y, -endFullVect.x);
        endNorm.normalize(arrowStyle.shaftThickness / 2);
        var end1:Point = end.add(endNorm);
        var end2:Point = end.subtract(endNorm);
        //figure out where the arrow head starts
        var headPnt:Point = endFullVect.clone();
        headPnt.normalize(headPnt.length - arrowStyle.headLength);
        headPnt = headPnt.add(curve);
        //calculate the arrowhead corners
        var headPntNorm:Point = endNorm.clone();
        headPntNorm.normalize(halfWidth);
        var edge1:Point = headPnt.add(headPntNorm);
        var edge2:Point = headPnt.subtract(headPntNorm);
        //Figure out where the arrow connects the the shaft, then calc the intersections
        var shaftCenter:Point = Point.interpolate(end, headPnt, arrowStyle.shaftPosition);
        var inter1:Point = getLineIntersection(curve1, end1, shaftCenter, edge1);
        var inter2:Point = getLineIntersection(curve2, end2, shaftCenter, edge2);
        //Figure out the control points
        var edgeCenter:Point = Point.interpolate(end, headPnt, arrowStyle.edgeControlPosition);
        var edgeNorm:Point = endNorm.clone();
        edgeNorm.normalize(halfWidth * arrowStyle.edgeControlSize);
        var edgeCntrl1:Point = edgeCenter.add(edgeNorm);
        var edgeCntrl2:Point = edgeCenter.subtract(edgeNorm);
        graphics.moveTo(start1.x, start1.y);
        //graphics.lineTo(inter1.x,inter1.y);
        graphics.curveTo(curve1.x, curve1.y, inter1.x, inter1.y);
        graphics.lineTo(edge1.x, edge1.y);
        graphics.curveTo(edgeCntrl1.x, edgeCntrl1.y, end.x, end.y);
        graphics.curveTo(edgeCntrl2.x, edgeCntrl2.y, edge2.x, edge2.y);
        graphics.lineTo(inter2.x, inter2.y);
        //graphics.lineTo(start2.x,start2.y);
        graphics.curveTo(curve2.x, curve2.y, start2.x, start2.y);
        graphics.lineTo(start1.x, start1.y);
    }

    /**
     *
     * Calculate the intersection between two lines. The intersection point
     * may not necesarily occur on either line segment. To only get the line
     * segment intersection, use <code>getLineSegmentIntersection</code> instead
     *
     */
    public static function getLineIntersection(a1:Point, a2:Point, b1:Point, b2:Point):Point {
        //calculate directional constants
        var k1:Number = (a2.y - a1.y) / (a2.x - a1.x);
        var k2:Number = (b2.y - b1.y) / (b2.x - b1.x);
        // if the directional constants are equal, the lines are parallel,
        // meaning there is no intersection point.
        if (k1 == k2)
            return null;
        var x:Number, y:Number;
        var m1:Number, m2:Number;
        // an infinite directional constant means the line is vertical
        if (!isFinite(k1)) {
            // so the intersection must be at the x coordinate of the line
            x = a1.x;
            m2 = b1.y - k2 * b1.x;
            y = k2 * x + m2;
            // same as above for line 2
        }
        else if (!isFinite(k2)) {
            m1 = a1.y - k1 * a1.x;
            x = b1.x;
            y = k1 * x + m1;
            // if neither of the lines are vertical
        }
        else {
            m1 = a1.y - k1 * a1.x;
            m2 = b1.y - k2 * b1.x;
            x = (m1 - m2) / (k2 - k1);
            y = k1 * x + m1;
        }
        return new Point(x, y);
    }

    /**
     *
     * @param graphics
     * @param start
     * @param end
     * @param style
     *
     */
    public static function drawArrowHead(graphics:Graphics, start:Point, end:Point, style:Object = null):void {
        var arrowStyle:ArrowStyle;
        if (style == null) {
            arrowStyle = new ArrowStyle();
        }
        else if (style is ArrowStyle) {
            arrowStyle = style as ArrowStyle;
        }
        else {
            arrowStyle = new ArrowStyle(style);
        }
        var vec:Point = end.subtract(start);
        var halfWidth:Number = (arrowStyle.headWidth != -1) ? arrowStyle.headWidth / 2 : vec.length / 2;
        var shaft:Point = vec.clone();
        shaft.normalize(vec.length * arrowStyle.shaftPosition);
        shaft = start.add(shaft);
        //Make the vect a normal to the line
        vec = new Point(vec.y, -vec.x);
        var tmp:Point = vec.clone();
        tmp.normalize(arrowStyle.shaftControlSize * halfWidth);
        var shaftCenter:Point = Point.interpolate(start, shaft, arrowStyle.shaftControlPosition);
        var baseCntrl1:Point = shaftCenter.add(tmp);
        var baseCntrl2:Point = shaftCenter.subtract(tmp);
        vec.normalize(halfWidth);
        var base1:Point = start.add(vec);
        var base2:Point = start.subtract(vec);
        var edgeCenter:Point = Point.interpolate(start, end, arrowStyle.edgeControlPosition);
        vec.normalize(halfWidth * arrowStyle.edgeControlSize);
        var edgeCntrl1:Point = edgeCenter.add(vec);
        var edgeCntrl2:Point = edgeCenter.subtract(vec);
        //Draw the arrow
        graphics.moveTo(base1.x, base1.y);
        graphics.curveTo(baseCntrl1.x, baseCntrl1.y, shaft.x, shaft.y);
        graphics.curveTo(baseCntrl2.x, baseCntrl2.y, base2.x, base2.y);
        graphics.curveTo(edgeCntrl2.x, edgeCntrl2.y, end.x, end.y);
        graphics.curveTo(edgeCntrl1.x, edgeCntrl1.y, base1.x, base1.y);
    }

    /**
     * Draws a star
     * @param g
     * @param nX int
     * @param nY int
     * @param nPoints int
     * @param nInnerRadius int
     * @param nOuterRadius int
     * @param nRotation Number
     * @example GraphicsUtil.drawStar (s.graphics,0,0,5,90,180,0.05);
     */
    public static function drawStar(g:Graphics, nX:int, nY:int, nPoints:int, nInnerRadius:int, nOuterRadius:int, nRotation:Number = 0):void {
        if (nPoints < 3) {
            return;
        }
        var nAngleDelta:Number = Math.PI * 2 / nPoints;
        nRotation = Math.PI * nRotation - 90 / 180;
        var nAngle:Number = nRotation;
        var nPenX:Number = nX + Math.cos(nAngle + nAngleDelta / 2) * nInnerRadius;
        var nPenY:Number = nY + Math.sin(nAngle + nAngleDelta / 2) * nInnerRadius;
        g.moveTo(nPenX, nPenY);
        nAngle += nAngleDelta;
        var i:int;
        for (i = 0; i < nPoints; i++) {
            nPenX = nX + Math.cos(nAngle) * nOuterRadius;
            nPenY = nY + Math.sin(nAngle) * nOuterRadius;
            g.lineTo(nPenX, nPenY);
            nPenX = nX + Math.cos(nAngle + nAngleDelta / 2) * nInnerRadius;
            nPenY = nY + Math.sin(nAngle + nAngleDelta / 2) * nInnerRadius;
            g.lineTo(nPenX, nPenY);
            nAngle += nAngleDelta;
        }
    }

    /**
     * Draw a speech bubble with the drawing API
     * @param    g    The Graphics in which to draw
     * @param    rect    A Rectangle instance defining the position and size of the bubble
     * @param    cornerRadius    The radius of the corners of the bubble (in px)
     * @param    point    A Point instance defining the position of the point of the speech bubble.
     */
    public static function drawSpeechBubble(g:Graphics, rect:Rectangle, cornerRadius:Number, point:Point):void {
        var r:Number = cornerRadius;
        var x:Number = rect.x;
        var y:Number = rect.y;
        var w:Number = rect.width;
        var h:Number = rect.height;
        var px:Number = point.x;
        var py:Number = point.y;
        var min_gap:Number = 20;
        var hgap:Number = Math.min(w - r - r, Math.max(min_gap, w / 5));
        var left:Number = px <= x + w / 2 ? (Math.max(x + r, px)) : (Math.min(x + w - r - hgap, px - hgap));
        var right:Number = px <= x + w / 2 ? (Math.max(x + r + hgap, px + hgap)) : (Math.min(x + w - r, px));
        var vgap:Number = Math.min(h - r - r, Math.max(min_gap, h / 5));
        var top:Number = py < y + h / 2 ? Math.max(y + r, py) : Math.min(y + h - r - vgap, py - vgap);
        var bottom:Number = py < y + h / 2 ? Math.max(y + r + vgap, py + vgap) : Math.min(y + h - r, py);
        //bottom right corner
        var a:Number = r - (r * 0.707106781186547);
        var s:Number = r - (r * 0.414213562373095);
        g.moveTo(x + w, y + h - r);
        if (r > 0) {
            if (px > x + w - r && py > y + h - r && Math.abs((px - x - w) - (py - y - h)) <= r) {
                g.lineTo(px, py);
                g.lineTo(x + w - r, y + h);
            }
            else {
                g.curveTo(x + w, y + h - s, x + w - a, y + h - a);
                g.curveTo(x + w - s, y + h, x + w - r, y + h);
            }
        }
        if (py > y + h && (px - x - w) < (py - y - h - r) && (py - y - h - r) > (x - px)) {
            // bottom edge
            g.lineTo(right, y + h);
            g.lineTo(px, py);
            g.lineTo(left, y + h);
        }
        g.lineTo(x + r, y + h);
        //bottom left corner
        if (r > 0) {
            if (px < x + r && py > y + h - r && Math.abs((px - x) + (py - y - h)) <= r) {
                g.lineTo(px, py);
                g.lineTo(x, y + h - r);
            }
            else {
                g.curveTo(x + s, y + h, x + a, y + h - a);
                g.curveTo(x, y + h - s, x, y + h - r);
            }
        }
        if (px < x && (py - y - h + r) < (x - px) && (px - x) < (py - y - r)) {
            // left edge
            g.lineTo(x, bottom);
            g.lineTo(px, py);
            g.lineTo(x, top);
        }
        g.lineTo(x, y + r);
        //top left corner
        if (r > 0) {
            if (px < x + r && py < y + r && Math.abs((px - x) - (py - y)) <= r) {
                g.lineTo(px, py);
                g.lineTo(x + r, y);
            }
            else {
                g.curveTo(x, y + s, x + a, y + a);
                g.curveTo(x + s, y, x + r, y);
            }
        }
        if (py < y && (px - x) > (py - y + r) && (py - y + r) < (x - px + w)) {
            //top edge
            g.lineTo(left, y);
            g.lineTo(px, py);
            g.lineTo(right, y);
        }
        g.lineTo(x + w - r, y);
        //top right corner
        if (r > 0) {
            if (px > x + w - r && py < y + r && Math.abs((px - x - w) + (py - y)) <= r) {
                g.lineTo(px, py);
                g.lineTo(x + w, y + r);
            }
            else {
                g.curveTo(x + w - s, y, x + w - a, y + a);
                g.curveTo(x + w, y + s, x + w, y + r);
            }
        }
        if (px > x + w && (py - y - r) > (x - px + w) && (px - x - w) > (py - y - h + r)) {
            // right edge
            g.lineTo(x + w, top);
            g.lineTo(px, py);
            g.lineTo(x + w, bottom);
        }
        g.lineTo(x + w, y + h - r);
    }

    /**
     * drawDash
     * Draws a dashed line from the point x1,y1 to the point x2,y2
     *
     * @param target Graphics the Graphics Class on which the dashed line will be drawn.
     * @param x1 Number starting position on x axis - <strong>required</strong>
     * @param y1 Number starting position on y axis - <strong>required</strong>
     * @param x2 Number finishing position on x axis - <strong>required</strong>
     * @param y2 Number finishing position on y axis - <strong>required</strong>
     * @param dashLength [optional] Number the number of pixels long each dash
     * will be.  Default = 5
     * @param spaceLength [optional] Number the number of pixels between each
     * dash.  Default = 5
     */
    public static function drawDash(target:Graphics, x1:Number, y1:Number, x2:Number, y2:Number, dashLength:Number = 5, spaceLength:Number = 5):void {

        var x:Number = x2 - x1;
        var y:Number = y2 - y1;
        var hyp:Number = Math.sqrt((x) * (x) + (y) * (y));
        var units:Number = hyp / (dashLength + spaceLength);
        var dashSpaceRatio:Number = dashLength / (dashLength + spaceLength);
        var dashX:Number = (x / units) * dashSpaceRatio;
        var spaceX:Number = (x / units) - dashX;
        var dashY:Number = (y / units) * dashSpaceRatio;
        var spaceY:Number = (y / units) - dashY;

        target.moveTo(x1, y1);
        while (hyp > 0) {
            x1 += dashX;
            y1 += dashY;
            hyp -= dashLength;
            if (hyp < 0) {
                x1 = x2;
                y1 = y2;
            }
            target.lineTo(x1, y1);
            x1 += spaceX;
            y1 += spaceY;
            target.moveTo(x1, y1);
            hyp -= spaceLength;
        }
        target.moveTo(x2, y2);
    }

    /**
     * Draws an arc from the starting position of x,y.
     *
     * @param target the Graphics Class that the Arc is drawn on.
     * @param x x coordinate of the starting pen position
     * @param y y coordinate of the starting pen position
     * @param radius radius of Arc.
     * @param arc = sweep of the arc. Negative values draw clockwise.
     * @param startAngle = [optional] starting offset angle in degrees.
     * @param yRadius = [optional] y radius of arc. if different than
     * radius, then the arc will draw as the arc of an oval.
     * default = radius.
     *
     * Based on mc.drawArc by Ric Ewing.
     * the version by Ric assumes that the pen is at x:y before this
     * method is called.  I explicitly move the pen to x:y to be
     * consistent with the behaviour of the other methods.
     */
    public static function drawArc(target:Graphics, x:Number, y:Number, radius:Number, arc:Number, startAngle:Number = 0, yRadius:Number = 0):void {

        if (arguments.length < 5) {
            throw new ArgumentError("DrawUtil.drawArc() - too few parameters, need atleast 5.");
            return;
        }

        // if startAngle is undefined, startAngle = 0
        if (startAngle == 0) {
            startAngle = 0;
        }
        // if yRadius is undefined, yRadius = radius
        if (yRadius == 0) {
            yRadius = radius;
        }

        // Init vars
        var segAngle:Number, theta:Number, angle:Number, angleMid:Number, segs:Number, ax:Number, ay:Number, bx:Number, by:Number, cx:Number, cy:Number;
        // no sense in drawing more than is needed :)
        if (DrawUtil.abs(arc) > 360) {
            arc = 360;
        }
        // Flash uses 8 segments per circle, to match that, we draw in a maximum
        // of 45 degree segments. First we calculate how many segments are needed
        // for our arc.
        segs = DrawUtil.ceil(DrawUtil.abs(arc) / 45);
        // Now calculate the sweep of each segment
        segAngle = arc / segs;
        // The math requires radians rather than degrees. To convert from degrees
        // use the formula (degrees/180)*Math.PI to get radians.
        theta = -(segAngle / 180) * Math.PI;
        // convert angle startAngle to radians
        angle = -(startAngle / 180) * Math.PI;
        // find our starting points (ax,ay) relative to the secified x,y
        ax = x - Math.cos(angle) * radius;
        ay = y - Math.sin(angle) * yRadius;
        // if our arc is larger than 45 degrees, draw as 45 degree segments
        // so that we match Flash's native circle routines.
        if (segs > 0) {
            target.moveTo(x, y);
            // Loop for drawing arc segments
            for (var i:int = 0; i < segs; ++i) {
                // increment our angle
                angle += theta;
                // find the angle halfway between the last angle and the new
                angleMid = angle - (theta / 2);
                // calculate our end point
                bx = ax + Math.cos(angle) * radius;
                by = ay + Math.sin(angle) * yRadius;
                // calculate our control point
                cx = ax + Math.cos(angleMid) * (radius / Math.cos(theta / 2));
                cy = ay + Math.sin(angleMid) * (yRadius / Math.cos(theta / 2));
                // draw the arc segment
                target.curveTo(cx, cy, bx, by);
            }
        }
    }

    /**
     * draws pie shaped wedges.  Could be employeed to draw pie charts.
     *
     * @param target the Graphics on which the wedge is to be drawn.
     * @param x x coordinate of the center point of the wedge
     * @param y y coordinate of the center point of the wedge
     * @param radius the radius of the wedge
     * @param arc the sweep of the wedge. negative values draw clockwise
     * @param startAngle the starting angle in degrees
     * @param yRadius [optional] the y axis radius of the wedge.
     * If not defined, then yRadius = radius.
     *
     * based on mc.drawWedge() - by Ric Ewing (ric at formequalsfunction.com) - version 1.4 - 4.7.2002
     */
    public static function drawWedge(target:Graphics, x:Number, y:Number, radius:Number, arc:Number, startAngle:Number = 0, yRadius:Number = 0):void {

        // if yRadius is undefined, yRadius = radius
        if (yRadius == 0) {
            yRadius = radius;
        }

        // move to x,y position
        target.moveTo(x, y);
        // if yRadius is undefined, yRadius = radius
        if (yRadius == 0) {
            yRadius = radius;
        }
        // Init vars
        var segAngle:Number, theta:Number, angle:Number, angleMid:Number, segs:Number, ax:Number, ay:Number, bx:Number, by:Number, cx:Number, cy:Number;
        // limit sweep to reasonable numbers
        if (DrawUtil.abs(arc) > 360) {
            arc = 360;
        }
        // Flash uses 8 segments per circle, to match that, we draw in a maximum
        // of 45 degree segments. First we calculate how many segments are needed
        // for our arc.
        segs = DrawUtil.ceil(DrawUtil.abs(arc) / 45);
        // Now calculate the sweep of each segment.
        segAngle = arc / segs;
        // The math requires radians rather than degrees. To convert from degrees
        // use the formula (degrees/180)*Math.PI to get radians.
        theta = -(segAngle / 180) * Math.PI;
        // convert angle startAngle to radians
        angle = -(startAngle / 180) * Math.PI;
        // draw the curve in segments no larger than 45 degrees.
        if (segs > 0) {
            // draw a line from the center to the start of the curve
            ax = x + Math.cos(startAngle / 180 * Math.PI) * radius;
            ay = y + Math.sin(-startAngle / 180 * Math.PI) * yRadius;
            target.lineTo(ax, ay);
            // Loop for drawing curve segments
            for (var i:int = 0; i < segs; ++i) {
                angle += theta;
                angleMid = angle - (theta / 2);
                bx = x + Math.cos(angle) * radius;
                by = y + Math.sin(angle) * yRadius;
                cx = x + Math.cos(angleMid) * (radius / Math.cos(theta / 2));
                cy = y + Math.sin(angleMid) * (yRadius / Math.cos(theta / 2));
                target.curveTo(cx, cy, bx, by);
            }
            // close the wedge by drawing a line to the center
            target.lineTo(x, y);
        }
    }

    /**
     * start draws a star shaped polygon.
     *
     * <blockquote>Note that the stars by default 'point' to
     * the right. This is because the method starts drawing
     * at 0 degrees by default, putting the first point to
     * the right of center. Negative values for points
     * draws the star in reverse direction, allowing for
     * knock-outs when used as part of a mask.</blockquote>
     *
     * @param target the Graphics that the star is drawn on
     * @param x x coordinate of the center of the star
     * @param y y coordinate of the center of the star
     * @param points the number of points on the star
     * @param innerRadius the radius of the inside angles of the star
     * @param outerRadius the radius of the outside angles of the star
     * @param angle [optional] the offet angle that the start is rotated
     *
     * based on mc.drawStar() - by Ric Ewing (ric at formequalsfunction.com) - version 1.4 - 4.7.2002
     */
    /*public static function drawStar(target:Graphics, x:Number, y:Number, points:uint, innerRadius:Number, outerRadius:Number, angle:Number = 0):void
     {

     // check that points is sufficient to build polygon
     if (points <= 2)
     {
     throw ArgumentError("DrawUtil.drawStar() - parameter 'points' needs to be atleast 3");
     return;
     }
     if (points > 2)
     {
     // init vars
     var step:Number, halfStep:Number, start:Number, n:Number, dx:Number, dy:Number;
     // calculate distance between points
     step = (Math.PI * 2) / points;
     halfStep = step / 2;
     // calculate starting angle in radians
     start = (angle / 180) * Math.PI;
     target.moveTo(x + (Math.cos(start) * outerRadius), y - (Math.sin(start) * outerRadius));
     // draw lines
     for (n = 1; n <= points; ++n)
     {
     dx = x + Math.cos(start + (step * n) - halfStep) * innerRadius;
     dy = y - Math.sin(start + (step * n) - halfStep) * innerRadius;
     target.lineTo(dx, dy);
     dx = x + Math.cos(start + (step * n)) * outerRadius;
     dy = y - Math.sin(start + (step * n)) * outerRadius;
     target.lineTo(dx, dy);
     }
     }
     }*/

    /**
     * a method for creating polygon shapes.  Negative values will draw
     * the polygon in reverse direction.  Negative drawing may be useful
     * for creating knock-outs in masks.
     *
     * @param target the Graphics that the polygon is to be drawn on
     * @param x x coordinate of the center of the polygon
     * @param y y coordinate of the center of the polygon
     * @param sides the number of sides (must be > 2)
     * @param radius the radius from the center point to the points
     * on the polygon
     * @param angle [optional] the starting offset angle (degrees) from
     * 0. Default = 0
     *
     * based on mc.drawPoly() - by Ric Ewing (ric at formequalsfunction.com) - version 1.4 - 4.7.2002
     */
    public static function drawPolygon(target:Graphics, x:Number, y:Number, sides:uint, radius:Number, angle:Number = 0):void {

        // check that sides is sufficient to build
        if (sides <= 2) {
            throw ArgumentError("DrawUtil.drawPolygon() - parameter 'sides' needs to be atleast 3");
            return;
        }
        if (sides > 2) {
            // init vars
            var step:Number, start:Number, n:Number, dx:Number, dy:Number;
            // calculate span of sides
            step = (Math.PI * 2) / sides;
            // calculate starting angle in radians
            start = (angle / 180) * Math.PI;
            target.moveTo(x + (Math.cos(start) * radius), y - (Math.sin(start) * radius));
            // draw the polygon
            for (n = 1; n <= sides; ++n) {
                dx = x + Math.cos(start + (step * n)) * radius;
                dy = y - Math.sin(start + (step * n)) * radius;
                target.lineTo(dx, dy);
            }
        }
    }

    /**
     * Burst is a method for drawing star bursts.  If you've ever worked
     * with an advertising department, you know what they are ;-)
     * Clients tend to want them, Developers tend to hate them...
     *
     * @param target Graphics where the Burst is to be drawn.
     * @param x x coordinate of the center of the burst
     * @param y y coordinate of the center of the burst
     * @param sides number of sides or points
     * @param innerRadius radius of the indent of the curves
     * @param outerRadius radius of the outermost points
     * @param angle [optional] starting angle in degrees. (defaults to 0)
     *
     * based on mc.drawBurst() - by Ric Ewing (ric at formequalsfunction.com) - version 1.4 - 4.7.2002
     */
    public static function drawBurst(target:Graphics, x:Number, y:Number, sides:uint, innerRadius:Number, outerRadius:Number, angle:Number = 0):void {

        // check that sides is sufficient to build
        if (sides <= 2) {
            throw ArgumentError("DrawUtil.drawBurst() - parameter 'sides' needs to be atleast 3");
            return;
        }
        if (sides > 2) {
            // init vars
            var step:Number, halfStep:Number, qtrStep:Number, start:Number, n:Number, dx:Number, dy:Number, cx:Number, cy:Number;
            // calculate length of sides
            step = (Math.PI * 2) / sides;
            halfStep = step / 2;
            qtrStep = step / 4;
            // calculate starting angle in radians
            start = (angle / 180) * Math.PI;
            target.moveTo(x + (Math.cos(start) * outerRadius), y - (Math.sin(start) * outerRadius));
            // draw curves
            for (n = 1; n <= sides; ++n) {
                cx = x + Math.cos(start + (step * n) - (qtrStep * 3)) * (innerRadius / Math.cos(qtrStep));
                cy = y - Math.sin(start + (step * n) - (qtrStep * 3)) * (innerRadius / Math.cos(qtrStep));
                dx = x + Math.cos(start + (step * n) - halfStep) * innerRadius;
                dy = y - Math.sin(start + (step * n) - halfStep) * innerRadius;
                target.curveTo(cx, cy, dx, dy);
                cx = x + Math.cos(start + (step * n) - qtrStep) * (innerRadius / Math.cos(qtrStep));
                cy = y - Math.sin(start + (step * n) - qtrStep) * (innerRadius / Math.cos(qtrStep));
                dx = x + Math.cos(start + (step * n)) * outerRadius;
                dy = y - Math.sin(start + (step * n)) * outerRadius;
                target.curveTo(cx, cy, dx, dy);
            }
        }
    }

    /**
     * draws a gear shape on the Graphics target.  The gear position
     * is indicated by the x and y arguments.
     *
     * @param target Graphics on which the gear is to be drawn.
     * @param x x coordinate of the center of the gear
     * @param y y coordinate of the center of the gear
     * @param sides number of teeth on gear. (must be > 2)
     * @param innerRadius radius of the indent of the teeth.
     * @param outerRadius outer radius of the teeth.
     * @param angle = [optional] starting angle in degrees. Defaults to 0.
     * @param holeSides [optional] draw a polygonal hole with this many sides (must be > 2)
     * @param holeRadius [optional] size of hole. Default = innerRadius/3.
     *
     * based on mc.drawGear() - by Ric Ewing (ric at formequalsfunction.com) - version 1.4 - 4.7.2002
     */
    public static function drawGear(target:Graphics, x:Number, y:Number, sides:uint, innerRadius:Number = 80, outerRadius:Number = 4, angle:Number = 0, holeSides:Number = 2, holeRadius:Number = 0):void {

        // check that sides is sufficient to build polygon
        if (sides <= 2) {
            throw ArgumentError("DrawUtil.drawGear() - parameter 'sides' needs to be atleast 3");
            return;
        }
        if (sides > 2) {
            // init vars
            var step:Number, qtrStep:Number, start:Number, n:Number, dx:Number, dy:Number;
            // calculate length of sides
            step = (Math.PI * 2) / sides;
            qtrStep = step / 4;
            // calculate starting angle in radians
            start = (angle / 180) * Math.PI;
            target.moveTo(x + (Math.cos(start) * outerRadius), y - (Math.sin(start) * outerRadius));
            // draw lines
            for (n = 1; n <= sides; ++n) {
                dx = x + Math.cos(start + (step * n) - (qtrStep * 3)) * innerRadius;
                dy = y - Math.sin(start + (step * n) - (qtrStep * 3)) * innerRadius;
                target.lineTo(dx, dy);
                dx = x + Math.cos(start + (step * n) - (qtrStep * 2)) * innerRadius;
                dy = y - Math.sin(start + (step * n) - (qtrStep * 2)) * innerRadius;
                target.lineTo(dx, dy);
                dx = x + Math.cos(start + (step * n) - qtrStep) * outerRadius;
                dy = y - Math.sin(start + (step * n) - qtrStep) * outerRadius;
                target.lineTo(dx, dy);
                dx = x + Math.cos(start + (step * n)) * outerRadius;
                dy = y - Math.sin(start + (step * n)) * outerRadius;
                target.lineTo(dx, dy);
            }
            // This is complete overkill... but I had it done already. :)
            if (holeSides > 2) {
                step = (Math.PI * 2) / holeSides;
                target.moveTo(x + (Math.cos(start) * holeRadius), y - (Math.sin(start) * holeRadius));
                for (n = 1; n <= holeSides; ++n) {
                    dx = x + Math.cos(start + (step * n)) * holeRadius;
                    dy = y - Math.sin(start + (step * n)) * holeRadius;
                    target.lineTo(dx, dy);
                }
            }
        }
    }

    /**
     * draws a line between two points. Make it horizontal or vertical
     *
     * @param target Graphics on which the gear is to be drawn.
     * @param x x coordinate of the center of the gear
     * @param y y coordinate of the center of the gear
     * @param length number of teeth on gear. (must be > 2)
     * @param direction TBD
     *
     *
     */
    public static function drawLine(target:Graphics, x:Number, y:Number, length:Number, direction:String = DrawUtil.HORIZONTAL_LINE):void {
        target.moveTo(x, y);
        switch (direction) {
            case DrawUtil.HORIZONTAL_LINE:
                target.lineTo(length, y);
                break;
            case DrawUtil.VERTICAL_LINE:
                target.moveTo(x, y);
                target.lineTo(x, length);
                break;
        }
    }

    /*
     * new abs function, about 25x faster than Math.abs
     */
    private static function abs(value:Number):Number {
        return value < 0 ? -value : value;
    }

    /*
     * new ceil function about 75% faster than Math.ceil.
     */
    private static function ceil(value:Number):Number {
        return (value % 1) ? int(value) + 1 : value;
    }
}
}

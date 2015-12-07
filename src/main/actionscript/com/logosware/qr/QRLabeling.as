/**************************************************************************
 * LOGOSWARE Class Library.
 *
 * Copyright 2009 (c) LOGOSWARE (http://www.logosware.com) All rights reserved.
 *
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
 * Place, Suite 330, Boston, MA 02111-1307 USA
 *
 **************************************************************************/
package com.logosware.qr {
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * QRLabeling is responsible for the bitmap data labeling
 *
 * @author Kenichi UENO
 * @contributor Andras Csizmadia - www.vpmedia.eu
 */
public class QRLabeling {

    /**
     * @private
     **/
    private var _bitmapData:BitmapData;

    /**
     * @private
     **/
    private var _minSize:uint;

    /**
     * @private
     **/
    private var _startColor:uint;

    /**
     * @private
     **/
    private var _pickedRectangles:Vector.<Rectangle>;

    /**
     * @private
     **/
    private var _pickedColors:Vector.<uint>;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     *
     * @param bitmapData Input image
     * @param minSize The minimum size
     * @param startColor Paint start color
     * @param isChangeOriginal Whether to paint the actual image
     **/
    public function QRLabeling(bitmapData:BitmapData, minSize:uint = 10, startColor:uint = 0xFFFFFFFE, isChangeOriginal:Boolean = true) {
        _minSize = minSize;
        _startColor = startColor;
        if (isChangeOriginal) {
            _bitmapData = bitmapData;
        } else {
            _bitmapData = bitmapData.clone();
        }
        _pickedRectangles = new Vector.<Rectangle>();
        _pickedColors = new Vector.<uint>()
        _process();
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Returns the rectangle range information of a obtained as a result of the labeling
     * @return List of picked rectangles
     **/
    public function getRects():Vector.<Rectangle> {
        return _pickedRectangles;
    }

    /**
     * Returns the color information that painted a range obtained as a result of the labeling
     * @return List of picked colors
     **/
    public function getColors():Vector.<uint> {
        return _pickedColors;
    }

    //----------------------------------
    //  Private methods
    //----------------------------------

    /**
     * Core function
     **/
    private function _process():void {
        var fillColor:uint = _startColor;
        var rectangle:Rectangle;
        while (_paintNextLabel(_bitmapData, 0xFF000000, fillColor)) {
            rectangle = _bitmapData.getColorBoundsRect(0xFFFFFFFF, fillColor);
            if (( rectangle.width > _minSize) && ( rectangle.height > _minSize )) {
                var _tempRect:Rectangle = rectangle.clone();
                _pickedRectangles.push(_tempRect);
                _pickedColors.push(fillColor);
            }
            fillColor--;
        }
    }

    /**
     * I paint to color fillcolor the area of pickcolor color of the next . I return false pickcolor is not found
     * @param bitmapData Source bitmap data
     * @param pickcolor Color to pick
     * @param fillcolor Color to paint
     * @return Whether there was a color
     **/
    private function _paintNextLabel(bitmapData:BitmapData, pickcolor:uint, fillcolor:uint):Boolean {
        var rectangle:Rectangle = bitmapData.getColorBoundsRect(0xFFFFFFFF, pickcolor);
        if ((rectangle.width > 0) && (rectangle.height > 0)) {
            var tempBmp:BitmapData = new BitmapData(rectangle.width, 1);
            tempBmp.copyPixels(bitmapData, new Rectangle(rectangle.topLeft.x, rectangle.topLeft.y, rectangle.width, 1), new Point(0, 0));
            var rect2:Rectangle = tempBmp.getColorBoundsRect(0xFFFFFFFF, pickcolor);
            bitmapData.floodFill(rect2.topLeft.x + rectangle.topLeft.x, rect2.topLeft.y + rectangle.topLeft.y, fillcolor);
            return true;
        }
        return false;
    }
}
}
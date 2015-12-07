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
/**
 * GF(2^8)
 *
 * @author Kenichi UENO
 * @contributor Andras Csizmadia - www.vpmedia.eu
 **/
public class G8Num {
    /**
     * @private
     **/
    private var _vector:uint;

    /**
     * @private
     **/
    private var _power:int;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     * @param power TBD
     **/
    public function G8Num(power:int) {
        setPower(power);
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * TBD
     * @param power TBD
     **/
    public function setPower(power:int):void {
        _power = power;
        if (_power < 0) {
            _vector = 0;
        } else {
            _power %= 255;
            _vector = GFstatic._power2vector_8[_power];
        }
    }

    /**
     * TBD
     * @param vector TBD
     **/
    public function setVector(vector:uint):void {
        _vector = vector;
        _power = GFstatic._vector2power_8[_vector];
    }

    /**
     * TBD
     * @return TBD
     **/
    public function getVector():uint {
        return _vector;
    }

    /**
     * I get the index
     * @return index
     **/
    public function getPower():int {
        return _power;
    }

    /**
     * I do addition . I take the xor of integer value to each other .
     * @param other TBD
     * @param TBD
     **/
    public function plus(other:G8Num):G8Num {
        var newVector:uint = _vector ^ other.getVector();
        return new G8Num(GFstatic._vector2power_8[ newVector ]);
    }

    /**
     * I do multiplication . I do addition of index between .
     * @param other TBD
     * @return TBD
     **/
    public function multiply(other:G8Num):G8Num {
        if ((_power < 0) || (other.getPower() < 0 )) {
            return new G8Num(-1);
        } else {
            return new G8Num(_power + other.getPower());
        }
    }

    /**
     * I can calculate the inverse . The original instance is not changed .
     * @return TBD
     **/
    public function inverse():G8Num {
        return new G8Num(255 - getPower());
    }
}
}
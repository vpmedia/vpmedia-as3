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
 * Classes for dealing with (2 ^ 4) GF
 *
 * @author Kenichi UENO
 * @contributor Andras Csizmadia - www.vpmedia.eu
 **/
public class G4Num {

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
     * @param power index
     **/
    public function G4Num(power:int) {
        setPower(power);
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * I specify the index
     * @param power index
     **/
    public function setPower(power:int):void {
        _power = power;
        if (_power < 0) {
            _vector = 0;
        } else {
            _power %= 15;
            _vector = GFstatic._power2vector_4[_power];
        }
    }

    /**
     * I specify an integer value
     * @param vector integer value
     **/
    public function setVector(vector:uint):void {
        _vector = vector;
        _power = GFstatic._vector2power_4[_vector];
    }

    /**
     * I get the integer value
     * @return index
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
     * @param other G4Num instance for which the plus
     * @return calculation result
     **/
    public function plus(other:G4Num):G4Num {
        var newVector:uint = _vector ^ other.getVector();
        return new G4Num(GFstatic._vector2power_4[ newVector ]);
    }

    /**
     * I do multiplication . I do addition of index between .‚
     * @param other TBD
     * @return TBD
     **/
    public function multiply(other:G4Num):G4Num {
        if ((_power == -1) || (other.getPower() == -1 )) {
            return new G4Num(-1);
        } else {
            return new G4Num(_power + other.getPower());
        }
    }
}
}
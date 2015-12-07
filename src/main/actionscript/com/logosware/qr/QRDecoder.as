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
import flash.system.System;
import flash.utils.unescapeMultiByte;

/**
 * QRDecoder Class decodes QR Code to string.
 *
 * @author Kenichi UENO
 * @contributor Andras Csizmadia - www.vpmedia.eu
 **/
public class QRDecoder {

    /**
     * @private
     */
    private var _xorPattern:Vector.<int> = Vector.<int>([1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0]);

    /**
     * @private
     */
    private var _fixed:Array;

    /**
     * @private
     */
    private var _qr:Array;

    /**
     * @private
     */
    private var _qrVersion:uint = 5;

    //----------------------------------
    //  QRDecoder
    //----------------------------------

    /**
     * Constructor
     */
    public function QRDecoder() {
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Function to store the QR code you want to analyze
     * @param The source data
     */
    public function setQR(qr:Array):void {
        _qr = qr;
        _qrVersion = (qr.length - 17) * 0.25;
    }

    /**
     *  Function for decoding the QR code stored in setQR
     */
    public function startDecode():String {
        // Read the form information
        var dataArray:Array;
        var unmaskedQR:Array;
        var wordArray:Array;
        var trueWordArray:Array;
        var result:Array;
        var resultFlg:uint;
        var resultStr:String;
        var qrSize:uint = _qrVersion * 4 + 17;
        dataArray = _decode15_5();
        // Unmask processing
        unmaskedQR = _unmask(dataArray);
        // Calculation of the functional area
        _makeFixed();
        // Read data
        wordArray = _getWords(unmaskedQR);
        // Reed-Solomon
        trueWordArray = _ReedSolomon(wordArray, dataArray);
        // Data code word decoding
        result = _readData(trueWordArray);
        resultFlg = result[0];
        if (resultFlg) {
            resultStr = result[1];
            return resultStr;
        }
        return null;
    }

    /**
     * Function to read each 8bit Reed-Solomon
     */
    private function _RS8bit(__dataArray:Array, __codeNum:uint, __errorNum:uint, __snum:uint):void {
        var __i:uint;
        var __j:uint;
        var __index:uint;
        var __dataLength:uint = __dataArray.length;
        var __Snum:uint = __errorNum;
        var __a:Array; // TBD
        var __e:Array; // TBD
        var __S:Array = new Array(__Snum); // TBD
        var __s:Array = new Array(__snum); // TBD
        var __tempNum1:G8Num;
        var __tempNum2:G8Num;

        // TBD
        for (__j = 0; __j < __Snum; __j++) {
            __S[__j] = new G8Num(-1);
        }

        for (__i = 0; __i < __dataLength; __i++) {
            __tempNum1 = new G8Num(0);
            __tempNum1.setVector(__dataArray[__dataLength - 1 - __i]);
            for (__j = 0; __j < __Snum; __j++) {
                __S[__j] = __S[__j].plus(__tempNum1.multiply(new G8Num(__i * __j)));
            }
        }
        __j = 0;
        for (__i = 0; __i < __Snum; __i++) {
            if (__S[__i].getPower() != -1) {
                __j++;
            }
        }
        if (__j == 0) { // TBD
            return;
        }
        // TBD
        for (__i = __snum; __i > 0; __i--) {
            if (_calcDet(__S, __i) != 0) {
                break;
            }
        }

        __snum = __i;
        __a = new Array(__snum);

        // TBD
        for (__i = 0; __i < __snum; __i++) {
            __a[__i] = new Array(__snum + 1);
            for (__j = 0; __j <= __snum; __j++) {
                __a[__i][__j] = new G8Num(__S[__i + __j].getPower());
            }
        }
        for (__i = 0; __i < __snum; __i++) {
            _reduceToLU(__a, __i);
        }
        for (__i = 0; __i < __snum; __i++) {
            for (__j = 0; __j < __snum; __j++) {
                if (__a[__i][__j].getPower() != -1) {
                    __s[__snum - 1 - __j] = __a[__i][__snum];
                }
            }
        }

        // TBD
        __e = new Array(__snum);
        __index = 0;
        for (__i = 0; __i < __dataLength; __i++) {
            __tempNum1 = new G8Num(__i * __snum);

            for (__j = __snum - 1; __j >= 1; __j--) {
                __tempNum2 = new G8Num(__i * __j);
                __tempNum1 = __tempNum1.plus(__tempNum2.multiply(__s[__snum - 1 - __j]));
            }

            __tempNum1 = __tempNum1.plus(__s[__snum - 1]);

            if (__tempNum1.getPower() < 0) {
                __e[__index] = __dataLength - 1 - __i;
                for (__j = 0; __j < __snum; __j++) {
                    __a[__j][__index] = new G8Num(__i * __j);
                }
                __a[__index][__snum] = new G8Num(__S[__index].getPower());
                __index++;

            }
        }

        for (__i = 0; __i < __snum; __i++) {
            _reduceToLU(__a, __i);
        }
        for (__i = 0; __i < __snum; __i++) {
            for (__j = 0; __j < __snum; __j++) {
                if (__a[__i][__j].getPower() == 0) {
                    __dataArray[__e[__j]] = __dataArray[__e[__j]] ^ (__a[__i][__snum].getVector() );
                }
            }
        }
    }

    /**
     * I calculate the determinant
     * @param TBD
     * @param TBD
     **/
    private function _calcDet(__Dat:Array, __size:uint):int {
        var __i:uint;
        var __j:uint;
        var __k:uint;
        var __doing:uint = 0;
        var __result:G8Num = new G8Num(0);
        var __tempNum:G8Num;
        var __todo:Array = new Array(__size);
        var __temp:Array = new Array(__size);
        for (__j = 0; __j < __size; __j++) {
            __todo[__j] = 1;
            __temp[__j] = new Array(__size);
            for (__i = 0; __i < __size; __i++) {
                __temp[__j][__i] = new G8Num(__Dat[__i + __j].getPower());
            }
        }
        // TBD
        while (__doing < __size) { // TBD
            for (__i = 0; __i < __size; __i++) {
                if (__todo[__i] == 1) {
                    if (__temp[__i][__doing].getPower() >= 0) {
                        __result.multiply(__temp[__i][__doing]);
                        __tempNum = __temp[__i][__doing].inverse();
                        // TBD
                        for (__j = __doing; __j < __size; __j++) {
                            __temp[__i][__j] = __temp[__i][__j].multiply(__tempNum);
                        }
                        // TBD
                        for (__k = 0; __k < __size; __k++) {
                            if ((__k != __i) && (__todo[__k] == 1) && (__temp[__k][__doing].getPower() >= 0)) {
                                __tempNum = new G8Num(__temp[__k][__doing].getPower());
                                for (__j = __doing; __j < __size; __j++) {
                                    __temp[__k][__j] = __temp[__k][__j].plus(__tempNum.multiply(__temp[__i][__j]));
                                }
                            }
                        }
                        __todo[__i] = 0;
                        break;
                    }
                }
            }
            if (__i == __size) {
                return 0;
            }
            __doing++;
        }
        return __result.getVector();
    }

    /**
     * I make a lower triangular matrix
     * @param __a TBD
     * @param __num TBD
     */
    private function _reduceToLU(__a:Array, __num:uint):void {
        var __i:uint;
        var __j:uint;
        var __it:uint;
        var __flg:uint;
        var __snum:uint = __a.length;
        var __tempNum:G8Num;

        for (__i = 0; __i < __snum; __i++) {
            __flg = 0;
            if (__a[__i][__num].getPower() != -1) {
                __flg = 1;
                for (__j = 0; __j < __num; __j++) {
                    if (__a[__i][__j].getPower() != -1) {
                        __flg = 0;
                    }
                }
            }
            if (__flg) {
                __it = __i;
                __i = __snum;
            }
        }
        __tempNum = __a[__it][__num].inverse();
        for (__j = __num; __j <= __snum; __j++) {
            __a[__it][__j] = __a[__it][__j].multiply(__tempNum);
        }
        for (__i = 0; __i < __snum; __i++) {
            if ((__i != __it) && (__a[__i][__num].getPower != -1 )) {
                __tempNum = new G8Num(__a[__i][__num].getPower());
                for (__j = __num; __j <= __snum; __j++) {
                    __a[__i][__j] = __a[__i][__j].plus(__a[__it][__j].multiply(__tempNum));
                }
            }
        }
    }

    /**
     *  I want to convert to a string binary
     * @param TBD
     * @return TBD
     */
    private function _readData(__dataCode:Array):Array {
        var __num2alphabet:Array = [
            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
            "A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
            "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
            "U", "V", "W", "X", "Y", "Z", " ", "$", "%", "*",
            "+", "-", ".", "/", ":"
        ];
        var __verMode:uint;
        var __stringBits:Array = [
            [10, 9, 8, 8],
            [12, 11, 16, 10],
            [14, 13, 16, 12]
        ];
        var __result:String = "";
        var __dataBin:Array;
        var __i:uint;
        var __mode:String;
        var __num:uint;
        var __tempNum:uint;
        var __tempNum2:uint;
        var __tempStr:String;
        var __isSuccess:uint = 1;

        if (_qrVersion < 10) {
            __verMode = 0;
        } else if (_qrVersion < 27) {
            __verMode = 1;
        } else if (_qrVersion < 41) {
            __verMode = 2;
        }

        __dataBin = _Hex2Bin(__dataCode);
        // To read more and more
        while (__dataBin.length > 0) {
            __mode = _readNstr(__dataBin, 4);
            switch (__mode) {
                case "0001": // number
                    __num = _readNnumber(__dataBin, __stringBits[__verMode][0]); // 10: ãƒãƒ¼ã‚¸ãƒ§ãƒ³ã«ä¾å­˜
                    for (__i = 0; __i < __num; __i += 3) {
                        if ((__num - __i) == 2) {
                            __tempNum = _readNnumber(__dataBin, 7);
                            __result += String("00" + __tempNum).substr(-2, 2);
                        } else if ((__num - __i) == 1) {
                            __tempNum = _readNnumber(__dataBin, 4);
                            __result += String("0" + __tempNum).substr(-1, 1);
                        } else {
                            __tempNum = _readNnumber(__dataBin, 10);
                            __result += String("000" + __tempNum).substr(-3, 3);
                        }
                    }
                    break;
                case "0010": // alphanumeric
                    __num = _readNnumber(__dataBin, __stringBits[__verMode][1]); // 9: ãƒãƒ¼ã‚¸ãƒ§ãƒ³ã«ä¾å­˜
                    for (__i = 0; __i < __num; __i += 2) {
                        if ((__num - __i) > 1) {
                            __tempNum = _readNnumber(__dataBin, 11);
                            __result += __num2alphabet[ Math.floor(__tempNum / 45) ] + __num2alphabet[ __tempNum % 45 ];
                        } else {
                            __tempNum = _readNnumber(__dataBin, 6);
                            __result += __num2alphabet[ __tempNum ];
                        }
                    }
                    break;
                case "0100": // 8 bit Byte
                    __num = _readNnumber(__dataBin, __stringBits[__verMode][2]); // 8: ãƒãƒ¼ã‚¸ãƒ§ãƒ³ã«ä¾å­˜
                    __tempStr = "";
                    for (__i = 0; __i < __num; __i++) {
                        __tempNum = _readNnumber(__dataBin, 8);

//								__result += String.fromCharCode(__tempNum);
                        __tempStr += "%" + _Hex2String(__tempNum);
                    }
                    System.useCodePage = true;
                    __result += unescapeMultiByte(__tempStr);

                    break;
                case "1000": // Kanji
                    __num = _readNnumber(__dataBin, __stringBits[__verMode][3]); // 8: ãƒãƒ¼ã‚¸ãƒ§ãƒ³ã«ä¾å­˜
                    for (__i = 0; __i < __num; __i++) {
                        __tempNum = _readNnumber(__dataBin, 13);
                        __tempNum2 = Math.floor(__tempNum / 0xC0);
                        __tempNum2 += ( __tempNum2 <= 0x1E ) ? 0x81 : 0xC1;
                        __tempNum %= 0xC0;
                        __tempNum += 0x40;
                        System.useCodePage = true;
                        __result += unescapeMultiByte("%" + _Hex2String(__tempNum2) + "%" + _Hex2String(__tempNum));
//								__result += "("+_Hex2String(__tempNum2)+_Hex2String(__tempNum)+")";
                    }
                    break;
                case "0000":
                case "000":
                case "00":
                case "0":
                    __tempNum = _readNnumber(__dataBin, __dataBin.length);
                    // Successful completion
                    break;
                default: // Not Supported
                    __isSuccess = 0;
                    __result += "UNSUPPORTED_MODE_DETECTED: " + __mode;
                    continue;
                    break;
            }
        }
        return [__isSuccess, __result];
    }

    /**
     * I heal in character 32-bit data
     * @param TBD
     * @return TBD
     */
    private function _Hex2String(__hex:uint):String {
        var __tempNum:uint = __hex >> 4;
        var __tempNum2:uint = __hex & 0xF;
        return String.fromCharCode(__tempNum + 48 + uint(__tempNum > 9) * 7) + String.fromCharCode(__tempNum2 + 48 + uint(__tempNum2 > 9) * 7);

    }

    /**
     * I read a string of N characters
     * @param TBD
     * @param TBD
     * @return TBD
     */
    private function _readNstr(__bin:Array, __length:uint):String {
        var __i:uint;
        var __retStr:String = "";
        if (__bin.length < __length) {
            __length = __bin.length;
        }
        for (__i = 0; __i < __length; __i++) {
            __retStr += __bin[0] ? "1" : "0";
            __bin.shift();
        }
        return __retStr;
    }

    /**
     * I read a number of N characters
     * @param TBD
     * @param TBD
     * @return TBD
     */
    private function _readNnumber(__bin:Array, __length:uint):uint {
        var __i:uint;
        var __retNum:uint = 0;
        for (__i = 0; __i < __length; __i++) {
            __retNum <<= 1;
            __retNum += __bin[0];
            __bin.shift();
        }
        return __retNum;
    }

    /**
     * I heal an array of binary sequence of hexadecimal
     * @param TBD
     * @return TBD
     */
    private function _Hex2Bin(__hex:Array):Array {
        var __i:uint;
        var __index:uint;
        var __loopCount:uint = __hex.length;
        var __retArray:Array = new Array(__loopCount * 8);
        for (__i = 0; __i < __loopCount; __i++) {
            __retArray[__index++] = (__hex[__i] >> 7) & 1;
            __retArray[__index++] = (__hex[__i] >> 6) & 1;
            __retArray[__index++] = (__hex[__i] >> 5) & 1;
            __retArray[__index++] = (__hex[__i] >> 4) & 1;
            __retArray[__index++] = (__hex[__i] >> 3) & 1;
            __retArray[__index++] = (__hex[__i] >> 2) & 1;
            __retArray[__index++] = (__hex[__i] >> 1) & 1;
            __retArray[__index++] = (__hex[__i] >> 0) & 1;
        }
        return __retArray;
    }

    /**
     * Reed-Solomon analysis
     * @param TBD
     * @param TBD
     * @return TBD
     */
    private function _ReedSolomon(__data:Array, __type:Array):Array {
        var __RSblock:Array;
        var __retArray:Array = [];
        var __dataNum:Array;
        var __errorNum:Array;
        var __i:uint;
        var __loopCount:uint;
        var __j:uint;
        var __loopCount2:uint;
        var __index:uint = 0;
        var __correctNum:uint = 0;
        switch (_qrVersion) {
            case 1:
                switch ((__type[0] << 1) + (__type[1] << 0)) {
                    case 0: // M
                        __RSblock = new Array(1);
                        __dataNum = [16];
                        __errorNum = [10];
                        break;
                    case 1: // L
                        __RSblock = new Array(1);
                        __dataNum = [19];
                        __errorNum = [7];
                        break;
                    case 2: // H
                        __RSblock = new Array(1);
                        __dataNum = [9];
                        __errorNum = [17];
                        break;
                    case 3: // Q
                        __RSblock = new Array(1);
                        __dataNum = [13];
                        __errorNum = [13];
                        break;
                }
                break;
            case 2:
                switch ((__type[0] << 1) + (__type[1] << 0)) {
                    case 0: // M
                        __RSblock = new Array(1);
                        __dataNum = [28];
                        __errorNum = [16];
                        break;
                    case 1: // L
                        __RSblock = new Array(1);
                        __dataNum = [34];
                        __errorNum = [10];
                        break;
                    case 2: // H
                        __RSblock = new Array(1);
                        __dataNum = [16];
                        __errorNum = [28];
                        break;
                    case 3: // Q
                        __RSblock = new Array(1);
                        __dataNum = [22];
                        __errorNum = [22];
                        break;
                }
                break;
            case 3:
                switch ((__type[0] << 1) + (__type[1] << 0)) {
                    case 0: // M
                        __RSblock = new Array(1);
                        __dataNum = [44];
                        __errorNum = [26];
                        break;
                    case 1: // L
                        __RSblock = new Array(1);
                        __dataNum = [55];
                        __errorNum = [15];
                        break;
                    case 2: // H
                        __RSblock = new Array(2);
                        __dataNum = [13, 13];
                        __errorNum = [22, 22];
                        break;
                    case 3: // Q
                        __RSblock = new Array(2);
                        __dataNum = [17, 17];
                        __errorNum = [18, 18];
                        break;
                }
                break;
            case 4:
                switch ((__type[0] << 1) + (__type[1] << 0)) {
                    case 0: // M
                        __RSblock = new Array(2);
                        __dataNum = [32, 32];
                        __errorNum = [18, 18];
                        break;
                    case 1: // L
                        __RSblock = new Array(1);
                        __dataNum = [80];
                        __errorNum = [20];
                        break;
                    case 2: // H
                        __RSblock = new Array(4);
                        __dataNum = [9, 9, 9, 9];
                        __errorNum = [16, 16, 16, 16];
                        break;
                    case 3: // Q
                        __RSblock = new Array(2);
                        __dataNum = [24, 24];
                        __errorNum = [26, 26];
                        break;
                }
                break;
            case 5:
                switch ((__type[0] << 1) + (__type[1] << 0)) {
                    case 0: // M
                        __RSblock = new Array(2);
                        __dataNum = [43, 43];
                        __errorNum = [24, 24];
                        break;
                    case 1: // L
                        __RSblock = new Array(1);
                        __dataNum = [108];
                        __errorNum = [26];
                        break;
                    case 2: // H
                        __RSblock = new Array(4);
                        __dataNum = [11, 11, 12, 12];
                        __errorNum = [22, 22, 22, 22];
                        break;
                    case 3: // Q
                        __RSblock = new Array(4);
                        __dataNum = [15, 15, 16, 16];
                        __errorNum = [18, 18, 18, 18];
                        break;
                }
                break;
            case 6:
                switch ((__type[0] << 1) + (__type[1] << 0)) {
                    case 0: // M
                        __RSblock = new Array(4);
                        __dataNum = [27, 27, 27, 27];
                        __errorNum = [16, 16, 16, 16];
                        break;
                    case 1: // L
                        __RSblock = new Array(2);
                        __dataNum = [68, 68];
                        __errorNum = [18, 18];
                        break;
                    case 2: // H
                        __RSblock = new Array(4);
                        __dataNum = [15, 15, 15, 15];
                        __errorNum = [28, 28, 28, 28];
                        break;
                    case 3: // Q
                        __RSblock = new Array(4);
                        __dataNum = [19, 19, 19, 19];
                        __errorNum = [24, 24, 24, 24];
                        break;
                }
                break;
            case 7:
                switch ((__type[0] << 1) + (__type[1] << 0)) {
                    case 0: // M
                        __RSblock = new Array(4);
                        __dataNum = [31, 31, 31, 31];
                        __errorNum = [18, 18, 18, 18];
                        break;
                    case 1: // L
                        __RSblock = new Array(2);
                        __dataNum = [78, 78];
                        __errorNum = [20, 20];
                        break;
                    case 2: // H
                        __RSblock = new Array(5);
                        __dataNum = [13, 13, 13, 13, 14];
                        __errorNum = [26, 26, 26, 26, 26];
                        break;
                    case 3: // Q
                        __RSblock = new Array(6);
                        __dataNum = [14, 14, 15, 15, 15, 15];
                        __errorNum = [18, 18, 18, 18, 18, 18];
                        break;
                }
                break;
            case 8:
                switch ((__type[0] << 1) + (__type[1] << 0)) {
                    case 0: // M
                        __RSblock = new Array(4);
                        __dataNum = [38, 38, 39, 39];
                        __errorNum = [22, 22, 22, 22];
                        break;
                    case 1: // L
                        __RSblock = new Array(2);
                        __dataNum = [97, 97];
                        __errorNum = [24, 24];
                        break;
                    case 2: // H
                        __RSblock = new Array(6);
                        __dataNum = [14, 14, 14, 14, 15, 15];
                        __errorNum = [26, 26, 26, 26, 26, 26];
                        break;
                    case 3: // Q
                        __RSblock = new Array(6);
                        __dataNum = [18, 18, 18, 18, 19, 19];
                        __errorNum = [22, 22, 22, 22, 22, 22];
                        break;
                }
                break;
            case 9:
                switch ((__type[0] << 1) + (__type[1] << 0)) {
                    case 0: // M
                        __RSblock = new Array(5);
                        __dataNum = [36, 36, 36, 37, 37];
                        __errorNum = [22, 22, 22, 22, 22];
                        break;
                    case 1: // L
                        __RSblock = new Array(2);
                        __dataNum = [116, 116];
                        __errorNum = [30, 30];
                        break;
                    case 2: // H
                        __RSblock = new Array(8);
                        __dataNum = [12, 12, 12, 12, 13, 13, 13, 13];
                        __errorNum = [24, 24, 24, 24, 24, 24, 24, 24];
                        break;
                    case 3: // Q
                        __RSblock = new Array(8);
                        __dataNum = [16, 16, 16, 16, 17, 17, 17, 17];
                        __errorNum = [20, 20, 20, 20, 20, 20, 20, 20];
                        break;
                }
                break;
            case 10:
                switch ((__type[0] << 1) + (__type[1] << 0)) {
                    case 0: // M
                        __RSblock = new Array(5);
                        __dataNum = [43, 43, 43, 43, 44];
                        __errorNum = [26, 26, 26, 26, 26];
                        break;
                    case 1: // L
                        __RSblock = new Array(4);
                        __dataNum = [68, 68, 69, 69];
                        __errorNum = [18, 18, 18, 18];
                        break;
                    case 2: // H
                        __RSblock = new Array(8);
                        __dataNum = [15, 15, 15, 15, 15, 15, 16, 16];
                        __errorNum = [28, 28, 28, 28, 28, 28, 28, 28];
                        break;
                    case 3: // Q
                        __RSblock = new Array(8);
                        __dataNum = [19, 19, 19, 19, 19, 19, 20, 20];
                        __errorNum = [24, 24, 24, 24, 24, 24, 24, 24];
                        break;
                }
                break;
            default:
                //trace( _qrVersion + ", " + (__type[0] << 1) + (__type[1] << 0) );
                return [];
                break
        }
        __loopCount = __RSblock.length;
        for (__i = 0; __i < __loopCount; __i++) {
            __RSblock[__i] = new Array();
        }
        __loopCount2 = __dataNum[__loopCount - 1];
        for (__j = 0; __j < __loopCount2; __j++) {
            for (__i = 0; __i < __loopCount; __i++) {
                // TBD
                if (__j < __dataNum[__i]) {
                    __RSblock[__i].push([ _readByteData(__data[__index++]) ]);
                }
            }
        }
        __correctNum = __errorNum[0] * 0.5;
        if (_qrVersion == 1) {
            switch ((__type[0] << 1) + (__type[1] << 0)) {
                case 0:
                    __correctNum = 4;
                    break;
                case 1:
                    __correctNum = 2;
                    break;
                case 2:
                    __correctNum = 8;
                    break;
                case 3:
                    __correctNum = 6;
                    break;
            }
        }
        if ((_qrVersion == 2) && ( ( (__type[0] << 1) + (__type[1] << 0) ) == 1 )) {
            __correctNum = 4;
        }
        if ((_qrVersion == 3) && ( ( (__type[0] << 1) + (__type[1] << 0) ) == 1 )) {
            __correctNum = 7;
        }

        __loopCount2 = __errorNum[0]; // TBD
        for (__j = 0; __j < __loopCount2; __j++) {
            for (__i = 0; __i < __loopCount; __i++) {
                __RSblock[__i].push([ _readByteData(__data[__index++]) ]);
            }
        }
        // TBD
        for (__i = 0; __i < __loopCount; __i++) {
            _RS8bit(__RSblock[__i], __dataNum[__i], __errorNum[__i], __correctNum);
        }


        // TBD
        for (__i = 0; __i < __loopCount; __i++) {
            __loopCount2 = __dataNum[__i];
            for (__j = 0; __j < __loopCount2; __j++) {
                __retArray.push(__RSblock[__i][__j]);
            }
        }
        return __retArray;
    }

    /**
     * I read the information of one byte
     * @param TBD
     * @return TBD
     */
    private function _readByteData(__byte:Array):uint {
        return (__byte[0] << 7) + (__byte[1] << 6) + (__byte[2] << 5) + (__byte[3] << 4) + (__byte[4] << 3) + (__byte[5] << 2) + (__byte[6] << 1) + (__byte[7] << 0);
    }

    /**
     * I read the bytes of information
     * @param __qr TBD
     * @return TBD
     */
    private function _getWords(__qr:Array):Array {
        var __checkArray:Array = [];
        var __cordNum:Array = [
            26, 44, 70, 100, 134, 172, 196, 242, 292, 346,
            404, 466, 532, 581, 655, 733, 815, 901, 991, 1085,
            1156, 1258, 1364, 1474, 1588, 1706, 1828, 1921, 2051, 2185,
            2323, 2465, 2611, 2761, 2876, 3034, 3196, 3362, 3532, 3706
        ]; // ãƒãƒ¼ã‚¸ãƒ§ãƒ³1ï½ž40ã¾ã§ã®ç·ã‚³ãƒ¼ãƒ‰èªžæ•°
        var __retArray:Array = new Array(__cordNum[_qrVersion - 1]);
        var __i:uint;
//			var __j:uint;
        var __loopCount:uint = __retArray.length;
        var __x:uint = _qrVersion * 4 + 16;
        var __y:uint = _qrVersion * 4 + 16;
        var __len:uint;
        var __toUp:uint = 1;
        var __toLeft:uint = 1;
        var __index:uint = 0;
        for (__i = 0; __i < __loopCount; __i++) {
            __retArray[__i] = new Array(8);
            __checkArray[__i] = new Array(8);
//				for( __j = 0; __j < 8; __j++ ){
//					__checkArray[__i][__j] = new Array(2);
//				}
        }
        for (__i = 0; __i < __loopCount; __i++) {
            for (__len = 0; __len < 8; __len++) {
                while (_isFixed(__x, __y)) {
                    if (__x == 6) {
                        __x--;
                    }
                    if (__toLeft) {
                        __x--;
                        __toLeft = 0;
                    } else {
                        __toLeft = 1;
                        if (__toUp) {
                            if (__y == 0) {
                                __x--;
                                __toUp = 0;
                            } else {
                                __x++;
                                __y--;
                            }
                        } else {
                            if (__y == (_qrVersion * 4 + 16)) {
                                __x--;
                                __toUp = 1;
                            } else {
                                __x++;
                                __y++;
                            }
                        }
                    }
                }
                _fixed[__y][__x] = 1;
                __retArray[__index][__len] = __qr[__y][__x];
                __checkArray[__index][__len] = [__x, __y];
            }
            __index++;
        }
        return __retArray;
    }

    /**
     * Function you want to unmask QR code
     * @param __typeData TBD
     * @return TBD
     */
    private function _unmask(__typeData:Array):Array {
        var __qrSize:uint = _qrVersion * 4 + 17;
        var __retArray:Array = new Array(__qrSize);
        var __i:uint;
        var __j:uint;
        for (__j = 0; __j < __qrSize; __j++) {
            __retArray[__j] = new Array(__qrSize);
        }
        switch ((__typeData[2] << 2) + (__typeData[3] << 1) + (__typeData[4])) {
            case 0: //(i+j)mod2==0
                for (__j = 0; __j < __qrSize; __j++) {
                    for (__i = 0; __i < __qrSize; __i++) {
                        __retArray[__i][__j] = _getQR(__j, __i) ^ int(( (__i + __j) % 2) == 0);
                    }
                }
                break;
            case 1: // i mod2==0
                for (__j = 0; __j < __qrSize; __j++) {
                    for (__i = 0; __i < __qrSize; __i++) {
                        __retArray[__i][__j] = _getQR(__j, __i) ^ int(( __i % 2) == 0);
                    }
                }
                break;
            case 2: //j mod3==0
                for (__j = 0; __j < __qrSize; __j++) {
                    for (__i = 0; __i < __qrSize; __i++) {
                        __retArray[__i][__j] = _getQR(__j, __i) ^ int(( __j % 3) == 0);
                    }
                }
                break;
            case 3: //(i+j)mod3==0
                for (__j = 0; __j < __qrSize; __j++) {
                    for (__i = 0; __i < __qrSize; __i++) {
                        __retArray[__i][__j] = _getQR(__j, __i) ^ int(( (__i + __j) % 3) == 0);
                    }
                }
                break;
            case 4: //((idiv2)+(jdiv3))mod2==0
                for (__j = 0; __j < __qrSize; __j++) {
                    for (__i = 0; __i < __qrSize; __i++) {
                        __retArray[__i][__j] = _getQR(__j, __i) ^ int(( (Math.floor(__i * 0.5) + Math.floor(__j / 3.0)) % 2) == 0);
                    }
                }
                break;
            case 5: //((ij)mod2+(ij)mod3)==0
                for (__j = 0; __j < __qrSize; __j++) {
                    for (__i = 0; __i < __qrSize; __i++) {
                        __retArray[__i][__j] = _getQR(__j, __i) ^ int(( ( (__i * __j) % 2 ) + ((__i * __j) % 3 ) ) == 0);
                    }
                }
                break;
            case 6: //((ij)mod2+(ij)mod3)mod2==0
                for (__j = 0; __j < __qrSize; __j++) {
                    for (__i = 0; __i < __qrSize; __i++) {
                        __retArray[__i][__j] = _getQR(__j, __i) ^ int(( ( ( (__i * __j) % 2 ) + ((__i * __j) % 3 ) ) % 2 ) == 0);
                    }
                }
                break;
            case 7: //((i+j)mod2+(ij)mod3)mod2==0
                for (__j = 0; __j < __qrSize; __j++) {
                    for (__i = 0; __i < __qrSize; __i++) {
                        __retArray[__i][__j] = _getQR(__j, __i) ^ int(( ( ( (__i + __j) % 2 ) + ((__i * __j) % 3 ) ) % 2 ) == 0);
                    }
                }
                break;
        }
        return __retArray;
    }

    /**
     * Function to specify another version in the range of function pattern
     */
    private function _makeFixed():void {
        var __i:int;
        var __j:int;
        var __k:int;
        var __l:int;
        _fixed = new Array(_qrVersion * 4 + 17);
        for (__i = 0; __i < (_qrVersion * 4 + 17); __i++) {
            _fixed[__i] = new Array(_qrVersion * 4 + 17);
        }
        switch (_qrVersion) {
            case 1:
                for (__i = 0; __i < 8; __i++) {
                    for (__j = 0; __j < 8; __j++) {
                        _fixed[__j][__i] =
                                _fixed[__j][_qrVersion * 4 + 9 + __i] =
                                        _fixed[_qrVersion * 4 + 9 + __j][__i] = 1;
                    }
                }
                for (__i = 0; __i < 8; __i++) {
                    _fixed[8][__i] =
                            _fixed[__i][8] =
                                    _fixed[_qrVersion * 4 + 9 + __i][8] =
                                            _fixed[8][_qrVersion * 4 + 9 + __i] = 1;
                }
                _fixed[8][8] = 1;
                for (__i = 9; __i < _qrVersion * 4 + 9; __i++) {
                    _fixed[6][__i] = _fixed[__i][6] = 1;
                }
                break;
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
                for (__i = 0; __i < 8; __i++) {
                    for (__j = 0; __j < 8; __j++) {
                        _fixed[__j][__i] =
                                _fixed[__j][_qrVersion * 4 + 9 + __i] =
                                        _fixed[_qrVersion * 4 + 9 + __j][__i] = 1;
                    }
                }
                for (__i = 0; __i < 8; __i++) {
                    _fixed[8][__i] =
                            _fixed[__i][8] =
                                    _fixed[_qrVersion * 4 + 9 + __i][8] =
                                            _fixed[8][_qrVersion * 4 + 9 + __i] = 1;
                }
                _fixed[8][8] = 1;
                for (__i = -2; __i <= 2; __i++) {
                    for (__j = -2; __j <= 2; __j++) {
                        _fixed[_qrVersion * 4 + 10 + __j][_qrVersion * 4 + 10 + __i] = 1;
                    }
                }
                for (__i = 9; __i < _qrVersion * 4 + 9; __i++) {
                    _fixed[6][__i] = _fixed[__i][6] = 1;
                }
                break;
            case 7:
            case 8:
            case 9:
            case 10:
            case 12:
            case 13:
                for (__i = 0; __i < 3; __i++) {
                    for (__j = 0; __j < 6; __j++) {
                        _fixed[__j][_qrVersion * 4 + 6 + __i] =
                                _fixed[_qrVersion * 4 + 6 + __i][__j] = 1;
                    }
                }
                for (__i = 0; __i < 8; __i++) {
                    for (__j = 0; __j < 8; __j++) {
                        _fixed[__j][__i] =
                                _fixed[__j][_qrVersion * 4 + 9 + __i] =
                                        _fixed[_qrVersion * 4 + 9 + __j][__i] = 1;
                    }
                }
                for (__i = 0; __i < 8; __i++) {
                    _fixed[8][__i] =
                            _fixed[__i][8] =
                                    _fixed[_qrVersion * 4 + 9 + __i][8] =
                                            _fixed[8][_qrVersion * 4 + 9 + __i] = 1;
                }
                _fixed[8][8] = 1;

                for (__k = 6; __k <= (_qrVersion * 4 + 10); __k += (_qrVersion * 2 + 2)) {
                    for (__l = 6; __l <= (_qrVersion * 4 + 10); __l += (_qrVersion * 2 + 2)) {
                        if (
                                !((__k == 6) && (__l == (_qrVersion * 4 + 10))) && !((__l == 6) && (__k == (_qrVersion * 4 + 10)))
                                ) {
                            for (__i = -2; __i <= 2; __i++) {
                                for (__j = -2; __j <= 2; __j++) {
                                    _fixed[__k + __j][__l + __i] = 1;
                                }
                            }
                        }
                    }
                }
                for (__i = 9; __i < _qrVersion * 4 + 9; __i++) {
                    _fixed[6][__i] = _fixed[__i][6] = 1;
                }
                break;
        }
    }

    /**
     *  Function that returns a bit pattern of the coordinates (x, y)
     */
    private function _getQR(x:uint, y:uint):uint {
        return _qr[y][x];
    }

    /**
     * Function that returns a function pattern information
     */
    private function _isFixed(x:uint, y:uint):uint {
        return _fixed[y][x];
    }

    /**
     * Function to decode the format information
     */
    private function _decode15_5():Array {
        var __str1:Array = new Array(15);
        var __str2:Array = new Array(15);
        var __i:uint;
        var __j:uint;
        var __S:Array = new Array(5); // syndrome
        var __s:Array = new Array(3); // error position variable
        var __tempNum1:G4Num;
        var __tempNum2:G4Num;
        var __retArray:Array = new Array(5); // data portion
        var __checkPattern:Array = new Array(15); // TBD

        // Syndrome array initialization
        for (__j = 0; __j < 5; __j++) {
            __S[__j] = new G4Num(-1);
        }
        // Get the format information
        for (__i = 0; __i <= 5; __i++) {
            __str1[__i] = _getQR(8, __i);
        }
        __str1[6] = _getQR(8, 7);
        __str1[7] = _getQR(8, 8);
        __str1[8] = _getQR(7, 8);
        for (__i = 0; __i <= 5; __i++) {
            __str1[__i + 9] = _getQR(5 - __i, 8);
        }
        for (__i = 0; __i <= 7; __i++) {
            __str2[__i] = _getQR(_qrVersion * 4 + 16 - __i, 8);
        }
        for (__i = 0; __i <= 6; __i++) {
            __str2[8 + __i] = _getQR(8, _qrVersion * 4 + 10 + __i);
        }

        // Unmasked
        for (__i = 0; __i < 15; __i++) {
            __checkPattern[__i] = __str1[14 - __i] ^ _xorPattern[__i];
        }

        for (__i = 0; __i < 15; __i++) {
            if (__checkPattern[__i]) {
                for (__j = 0; __j < 5; __j += 2) {
                    __S[__j] = __S[__j].plus(new G4Num(__i * (__j + 1)));
                }
            }
        }
        __S[1] = __S[0].multiply(__S[0]);
        __S[3] = __S[1].multiply(__S[1]);
        __s[0] = new G4Num(__S[0].getPower());
        __tempNum1 = __S[4].plus(__S[1].multiply(__S[2]));
        __tempNum2 = __S[2].plus(__S[0].multiply(__S[1]));
        if ((__tempNum1.getPower() < 0) || (__tempNum2.getPower() < 0)) {
            __s[1] = new G4Num(-1);
        } else {
            __s[1] = new G4Num(__tempNum1.getPower() - __tempNum2.getPower() + 15);
        }
        __tempNum1 = __S[1].multiply(__s[0]);
        __tempNum2 = __S[0].multiply(__s[1]);
        __s[2] = __S[2].plus(__tempNum1.plus(__tempNum2));

        for (__i = 0; __i < 5; __i++) {
            __tempNum1 = new G4Num((__i) * 3);
            __tempNum2 = new G4Num((__i) * 2);
            __tempNum1 = __tempNum1.plus(__tempNum2.multiply(__s[0]));
            __tempNum2 = new G4Num((__i));
            __tempNum1 = __tempNum1.plus(__tempNum2.multiply(__s[1]));
            __tempNum1 = __tempNum1.plus(__s[2]);

            if (__tempNum1.getPower() < 0) {
                __retArray[__i] = __checkPattern[__i] ^ 1;
            } else {
                __retArray[__i] = __checkPattern[__i];
            }
        }

        return __retArray;
    }

}
}
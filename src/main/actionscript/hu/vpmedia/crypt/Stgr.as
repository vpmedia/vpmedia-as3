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

package hu.vpmedia.crypt {
import flash.display.BitmapData;

import hu.vpmedia.errors.StaticClassError;

/**
 * Steganography implementation
 *
 */
public class Stgr {
    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * @private
     */
    private static const STATE_HIDE:uint = 1;

    /**
     * @private
     */
    private static const STATE_FILL_ZERO:uint = 2;

    /**
     * @private
     */
    public function Stgr() {
        throw new StaticClassError();
    }

    //----------------------------------
    //  Static methods
    //----------------------------------

    /**
     * @private
     */
    public static function embedText(text:String, bmp:BitmapData):BitmapData {
        // initially, we'll be hiding characters in the image
        var state:uint = STATE_HIDE;
        // holds the index of the character that is being hidden
        var charIndex:int = 0;
        // holds the value of the character converted to integer
        var charValue:int = 0;
        // holds the index of the color element (R or G or B) that is currently being processed
        var pixelElementIndex:uint = 0;
        // holds the number of trailing zeros that have been added when finishing the process
        var zeros:int = 0;
        // hold pixel elements
        var R:int = 0, G:int = 0, B:int = 0;
        // save bitmap dimensions
        const bmpHeight:int = bmp.height;
        const bmpWidth:int = bmp.width;
        // pass through the rows
        for (var i:int = 0; i < bmpHeight; i++) {
            // pass through each row
            for (var j:int = 0; j < bmpWidth; j++) {
                // holds the pixel that is currently being processed
                const pixelColor:uint = bmp.getPixel(j, i);
                const pixelR:uint = (pixelColor >> 16 & 0xFF);
                const pixelG:uint = (pixelColor >> 8 & 0xFF);
                const pixelB:uint = (pixelColor & 0xFF);
                // now, clear the least significant bit (LSB) from each pixel element
                R = pixelR - pixelR % 2;
                G = pixelG - pixelG % 2;
                B = pixelB - pixelB % 2;
                // for each pixel, pass through its elements (RGB)
                for (var n:int = 0; n < 3; n++) {
                    // check if new 8 bits has been processed
                    if (pixelElementIndex % 8 == 0) {
                        // check if the whole process has finished
                        // we can say that it's finished when 8 zeros are added
                        if (state == STATE_FILL_ZERO && zeros == 8) {
                            // apply the last pixel on the image
                            // even if only a part of its elements have been affected
                            if ((pixelElementIndex - 1) % 3 < 2) {
                                bmp.setPixel(j, i, getHexByRGB(R, G, B));
                            }
                            // return the bitmap with the text hidden in
                            return bmp;
                        }
                        // check if all characters has been hidden
                        if (charIndex >= text.length) {
                            // start adding zeros to mark the end of the text
                            state = STATE_FILL_ZERO;
                        }
                        else {
                            // move to the next character and process again
                            charValue = text.charCodeAt(charIndex++);
                            //trace("Processing", charIndex, charValue);
                        }
                    }
                    // check which pixel element has the turn to hide a bit in its LSB
                    // TODO: Refactor to if case from switch (C vs AS3 opt.)
                    switch (pixelElementIndex % 3) {
                        case 0:
                        {
                            if (state == STATE_HIDE) {
                                // the rightmost bit in the character will be (charValue % 2)
                                // to put this value instead of the LSB of the pixel element
                                // just add it to it
                                // recall that the LSB of the pixel element had been cleared
                                // before this operation
                                R += charValue % 2;

                                // removes the added rightmost bit of the character
                                // such that next time we can reach the next one
                                charValue /= 2;
                            }
                        }
                            break;
                        case 1:
                        {
                            if (state == STATE_HIDE) {
                                G += charValue % 2;

                                charValue /= 2;
                            }
                        }
                            break;
                        case 2:
                        {
                            if (state == STATE_HIDE) {
                                B += charValue % 2;

                                charValue /= 2;
                            }

                            bmp.setPixel(j, i, getHexByRGB(R, G, B));
                        }
                            break;
                    }
                    pixelElementIndex++;
                    if (state == STATE_FILL_ZERO) {
                        // increment the value of zeros until it is 8
                        zeros++;
                    }
                }
            }
        }
        return bmp;
    }

    /**
     * @private
     */
    public static function extractText(bmp:BitmapData):String {
        var colorUnitIndex:int = 0;
        var charValue:int = 0;
        // save bitmap dimensions
        const bmpHeight:int = bmp.height;
        const bmpWidth:int = bmp.width;
        // holds the text that will be extracted from the image
        var extractedText:String = "";
        // pass through the rows
        for (var i:int = 0; i < bmpHeight; i++) {
            // pass through each row
            for (var j:int = 0; j < bmpWidth; j++) {
                const pixelColor:uint = bmp.getPixel(j, i);
                const pixelR:uint = (pixelColor >> 16 & 0xFF);
                const pixelG:uint = (pixelColor >> 8 & 0xFF);
                const pixelB:uint = (pixelColor & 0xFF);
                // for each pixel, pass through its elements (RGB)
                for (var n:int = 0; n < 3; n++) {
                    // TODO: Refactor to if case from switch (C vs AS3 opt.)
                    switch (colorUnitIndex % 3) {
                        case 0:
                        {
                            // get the LSB from the pixel element (will be pixel.R % 2)
                            // then add one bit to the right of the current character
                            // this can be done by (charValue = charValue * 2)
                            // replace the added bit (which value is by default 0) with
                            // the LSB of the pixel element, simply by addition
                            charValue = charValue * 2 + pixelR % 2;
                        }
                            break;
                        case 1:
                        {
                            charValue = charValue * 2 + pixelG % 2;
                        }
                            break;
                        case 2:
                        {
                            charValue = charValue * 2 + pixelB % 2;
                        }
                            break;
                    }
                    colorUnitIndex++;
                    // if 8 bits has been added,
                    // then add the current character to the result text
                    if (colorUnitIndex % 8 == 0) {
                        // reverse? of course, since each time the process occurs
                        // on the right (for simplicity)
                        charValue = reverseBits(charValue);
                        // can only be 0 if it is the stop character (the 8 zeros)
                        if (charValue == 0) {
                            return extractedText;
                        }
                        // convert the character value from int to char
                        //char c = (char)charValue;
                        var c:String = String.fromCharCode(charValue);
                        // add the current character to the result text
                        extractedText += c.toString();
                    }
                }
            }
        }
        return extractedText;
    }

    /**
     * @private
     */
    [Inline]
    private static function reverseBits(n:int):int {
        var result:int = 0;
        for (var i:int = 0; i < 8; i++) {
            result = result * 2 + n % 2;
            n /= 2;
        }
        return result;
    }

    /**
     * @private
     */
    [Inline]
    private static function getHexByRGB(r:uint, g:uint, b:uint):uint {
        var result:uint = (r << 16 | g << 8 | b);
        return result;
    }
}
}
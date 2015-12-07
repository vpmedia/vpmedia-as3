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
package hu.vpmedia.filters {
public class ColorMatrixArrays {
    public static const DIGITAL_NEGATIVE:Array = [-1, 0, 0, 0, 255, 0, -1, 0, 0, 255, 0, 0, -1, 0, 255, 0, 0, 0, 1, 0];
    public static const GRAYSCALE:Array = [0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0];

    public static function getSaturationArray(nValue:Number):Array {
        var nRed:Number = 0.3086;
        var nGreen:Number = 0.6094;
        var nBlue:Number = 0.0820;
        var nA:Number = 1 - nValue * nRed + nValue;
        var nB:Number = 1 - nValue * nGreen;
        var nC:Number = 1 - nValue * nBlue;
        var nD:Number = 1 - nValue * nRed;
        var nE:Number = 1 - nValue * nGreen + nValue;
        var nF:Number = 1 - nValue * nBlue;
        var nG:Number = 1 - nValue * nRed;
        var nH:Number = 1 - nValue * nGreen;
        var nI:Number = 1 - nValue * nBlue + nValue;
        return [nA, nB, nC, 0, 0, nD, nE, nF, 0, 0, nG, nH, nI, 0, 0, 0, 0, 0, 1, 0];
    }

    public static function getContrastArray(nValue:Number):Array {
        var nScale:Number = nValue * 11;
        var nOffset:Number = 63.6 - nValue * 698.5;
        return [nScale, 0, 0, 0, nOffset, 0, nScale, 0, 0, nOffset, 0, 0, nScale, 0, nOffset, 0, 0, 0, 1, 0];
    }
}
}

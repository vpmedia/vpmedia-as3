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
import flash.filters.ConvolutionFilter;

/**
 * A Sharpen Filter.
 */
public class SharpenFilter extends ConvolutionFilter {
    private var _amount:int;

    /**
     * @param p_amount Sharpen value
     */
    public function SharpenFilter(p_amount:int) {
        super(3, 3, [0, 0, 0, 0, 1, 0, 0, 0, 0], 1);
        amount = p_amount;
    }

    public function set amount(p_amount:int):void {
        _amount = p_amount;
        var a:Number = p_amount / -100;
        var b:Number = a * -8 + 1;
        matrix = [a, a, a, a, b, a, a, a, a];
    }

    public function get amount():int {
        return _amount;
    }
}
}

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
/* implementations */

import flash.filters.ConvolutionFilter;

/* start class */
public class BigEdgeFilter extends ConvolutionFilter {
    /* constructor */
    function BigEdgeFilter() {
        super(7, 7, [0, 0, 0, 0, 0, 0, 0, 0, -2, -2, -2, -2, -2, 0, 0, -2, -3, -3, -3, -2, 0, 0, -2, -3, 53, -3, -2, 0, 0, -2, -3, -3, -3, -2, 0, 0, -2, -2, -2, -2, -2, 0, 0, 0, 0, 0, 0, 0, 0], 1, 0);
    }
}
}

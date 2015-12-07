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
package hu.vpmedia.components.core {

/**
 * TBD
 */
public final class InvalidationType {

    /**
     * TBD
     */
    public static const ALL:uint = 0;

    /**
     * TBD
     */
    public static const DATA:uint = 1;

    /**
     * TBD
     */
    public static const SIZE:uint = 2;

    /**
     * TBD
     */
    public static const STATE:uint = 4;

    /**
     * TBD
     */
    public static const STYLE:uint = 8;

    /**
     * TBD
     */
    public static const LAYOUT:uint = 16;

    //--------------------------------------
    //  Constructor
    //--------------------------------------

    /**
     * TBD
     */
    public function InvalidationType() {
        throw new Error("Error! Cannot instantiate 'InvalidationTypes' class.");
    }
}
}

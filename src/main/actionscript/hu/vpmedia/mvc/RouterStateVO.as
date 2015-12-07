/*
 * =BEGIN CLOSED LICENSE
 *
 * Copyright (c) 2014 Andras Csizmadia
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
package hu.vpmedia.mvc {
/**
 * TBD
 */
public final class RouterStateVO {
    /**
     * TBD
     */
    public var type:String;

    /**
     * TBD
     */
    public var currentState:String;

    /**
     * TBD
     */
    public static const EXIT_CALLBACK:String = "exit";

    /**
     * TBD
     */
    public static const ENTER_CALLBACK:String = "enter";

    /**
     * Constructor
     */
    public function RouterStateVO(currentState:String, type:String) {
        this.currentState = currentState;
        this.type = type;
    }

    public function toString():String {
        return "[RouterStateVO"
                + " currentState=" + currentState
                + " type=" + type
                + "]";
    }
}
}

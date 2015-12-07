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

package hu.vpmedia.entity.core {
/**
 * TBD
 */
public class BaseEntityNodePool {

    /**
     * @private
     */
    private var tail:BaseEntityNode;

    /**
     * @private
     */
    private var nodeClass:Class;

    /**
     * Constructor
     *
     * @param nodeClass The pool object class type
     */
    public function BaseEntityNodePool(nodeClass:Class) {
        this.nodeClass = nodeClass;
    }

    /**
     * Get a pooled object.
     */
    public function checkOut():BaseEntityNode {
        if (tail) {
            var node:BaseEntityNode = tail;
            tail = tail.previous;
            node.previous = null;
            return node;
        }
        else {
            return new nodeClass();
        }
    }

    /**
     * Put back a pooled object.
     */
    public function checkIn(node:BaseEntityNode):void {
        node.next = null;
        node.previous = tail;
        tail = node;
    }

    /**
     * Clear the pool.
     */
    public function dispose():void {
        while (tail) {
            var node:BaseEntityNode = tail;
            tail = tail.previous;
            node.previous = null;
            node.next = null;
        }
        tail = null;
    }
}
}
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
import hu.vpmedia.framework.IBaseDisposable;

import org.osflash.signals.Signal;

/**
 * TBD
 */
public class BaseEntityNodeList implements IBaseDisposable {

    /**
     * TBD
     */
    public var head:BaseEntityNode;

    /**
     * TBD
     */
    public var tail:BaseEntityNode;

    /**
     * TBD
     */
    public var nodeAdded:Signal;

    /**
     * TBD
     */
    public var nodeRemoved:Signal;

    /**
     * Constructor
     */
    public function BaseEntityNodeList() {
        nodeAdded = new Signal(BaseEntityNode);
        nodeRemoved = new Signal(BaseEntityNode);
    }

    /**
     * TBD
     */
    public function add(node:BaseEntityNode):void {
        if (!head) {
            head = tail = node;
            node.next = node.previous = null;
        }
        else {
            tail.next = node;
            node.previous = tail;
            node.next = null;
            tail = node;
        }
        nodeAdded.dispatch(node);
    }

    /**
     * TBD
     */
    public function remove(node:BaseEntityNode):void {
        if (head == node) {
            head = head.next;
        }
        if (tail == node) {
            tail = tail.previous;
        }
        if (node.previous) {
            node.previous.next = node.next;
        }
        if (node.next) {
            node.next.previous = node.previous;
        }
        node.previous = null;
        node.next = null;
        nodeRemoved.dispatch(node);
    }

    /**
     * TBD
     */
    public function dispose():void {
        while (head) {
            var node:BaseEntityNode = head;
            head = node.next;
            node.previous = null;
            node.next = null;
            nodeRemoved.dispatch(node);
        }
        tail = null;
    }

    /**
     * TBD
     */
    public function get length():uint {
        var result:uint = 0;
        var item:BaseEntityNode = head;
        while (item) {
            item = item.next;
            result++;
        }
        return result;
    }
}
}

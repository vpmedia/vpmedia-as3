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
import hu.vpmedia.utils.ClassUtil;

/**
 * TBD
 */
public class BaseEntityList implements IBaseDisposable {

    /**
     * Constructor
     */
    public function BaseEntityList() {

    }

    /**
     * TBD
     */
    public var head:BaseEntity;

    /**
     * TBD
     */
    public var tail:BaseEntity;

    /**
     * TBD
     */
    public function add(entity:BaseEntity):void {
        if (!head) {
            head = tail = entity;
            entity.next = entity.previous = null;
        }
        else {
            tail.next = entity;
            entity.previous = tail;
            entity.next = null;
            tail = entity;
        }
    }

    /**
     * TBD
     */
    public function remove(entity:BaseEntity):void {
        if (head == entity) {
            head = head.next;
        }
        if (tail == entity) {
            tail = tail.previous;
        }
        if (entity.previous) {
            entity.previous.next = entity.next;
        }
        if (entity.next) {
            entity.next.previous = entity.previous;
        }
        entity.previous = null;
        entity.next = null;
    }

    /**
     * TBD
     */
    public function has(value:BaseEntity):Boolean {
        for (var entity:BaseEntity = head; entity; entity = entity.next) {
            if (entity === value) {
                return true;
            }
        }
        return false;
    }

    /**
     * TBD
     */
    public function getByName(value:String):BaseEntity {
        for (var entity:BaseEntity = head; entity; entity = entity.next) {
            if (entity.name == value) {
                return entity;
            }
        }
        return null;
    }

    /**
     * TBD
     */
    public function getByComponent(value:Object):BaseEntity {
        for (var entity:BaseEntity = head; entity; entity = entity.next) {
            if (entity.getComponent(ClassUtil.getConstructor(value)) == value) {
                return entity;
            }
        }
        return null;
    }

    /**
     * TBD
     */
    public function dispose():void {
        while (head) {
            var entity:BaseEntity = head;
            head = head.next;
            entity.previous = null;
            entity.next = null;
        }
        tail = null;
    }
}
}

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

package hu.vpmedia.profilers {
import flash.system.System;
import flash.utils.Dictionary;

/**
 * TBD
 */
public class MemoryProfiler implements IBaseProfiler {

    /**
     * TBD
     */
    public var dict:Dictionary;

    /**
     * TBD
     */
    public var data:ProfilerData;

    /**
     * TBD
     */
    public function MemoryProfiler() {
        dict = new Dictionary(true);
        data = new ProfilerData();
    }

    /**
     * TBD
     */
    public function dispose():void {
        for (var p:* in dict) {
            delete dict[p];
        }
        dict = null;
        data = null;
    }

    /**
     * TBD
     */
    public function step(timeDelta:Number):void {
        data.step(System.totalMemory >> 12);
    }

    /**
     * TBD
     */
    public function addInstance(value:*, identifier:String = null):void {
        dict[value] = identifier == null ? value.toString() : identifier;
    }

    /**
     * TBD
     */
    public function getIdentifiers():Vector.<String> {
        var result:Vector.<String> = new Vector.<String>();
        for each (var i:String in dict) {
            result.push(i);
        }
        return result;
    }

    /**
     * TBD
     */
    public function size():uint {
        return getIdentifiers().length;
    }

    /**
     * TBD
     */
    public function isEmpty():Boolean {
        for each (var i:String in dict)
            return false;
        return true;
    }


}
}


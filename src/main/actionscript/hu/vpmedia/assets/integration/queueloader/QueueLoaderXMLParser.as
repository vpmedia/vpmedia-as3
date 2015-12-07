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
package hu.vpmedia.assets.integration.queueloader {
import flash.display.DisplayObject;

import hu.vpmedia.assets.AssetLoader;
import hu.vpmedia.errors.StaticClassError;

/**
 * TBD
 */
public final class QueueLoaderXMLParser {
    /**
     * TBD
     */
    public function QueueLoaderXMLParser() {
        throw new StaticClassError();
    }

    /**
     * TBD
     */
    public static function parseXML(assetLoader:AssetLoader, xml:XML, scope:* = null):void {
        var xmlList:XMLList = xml..item;
        var prefix:String = xml..@prefix;
        var n:int = xmlList.length();
        for (var i:int = 0; i < n; i++) {
            var src:String = ((prefix != "") ? prefix : "") + xmlList[i].@src;
            var info:Object = {};
            var container:DisplayObject = (scope != null) ? ((scope[xmlList[i].@container] != null) ? scope[xmlList[i].@container] : ((xmlList[i].@container == "this") ? scope : null)) : null;
            info.container = container;
            if (xmlList[i].info != null) {
                var infoList:XMLList = xmlList[i].info.children();
                for (var j:int = 0; j < infoList.length(); j++)
                    info[infoList[j].name()] = infoList[j];
            }
            assetLoader.add(src, int(info.priority));
        }

    }
}
}
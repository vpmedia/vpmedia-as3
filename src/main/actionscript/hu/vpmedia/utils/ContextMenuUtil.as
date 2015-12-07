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
package hu.vpmedia.utils {
import flash.display.DisplayObjectContainer;
import flash.ui.ContextMenu;
import flash.ui.ContextMenuItem;

import hu.vpmedia.errors.StaticClassError;

PLATFORM::WEB {
    import hu.vpmedia.ui.BaseContextMenuItem;
}

/**
 * Contains reusable methods for ContextMenu manipulation.
 *
 * @see flash.ui.ContextMenu
 * @see help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/ui/ContextMenu.html
 */
public class ContextMenuUtil {

    /**
     * @private
     */
    public function ContextMenuUtil() {
        throw new StaticClassError();
    }
        
    PLATFORM::WEB {

        /**
         * Add items to given scope
         */
        public static function addItems(root:DisplayObjectContainer, dataProvider:Vector.<BaseContextMenuItem>):void {
            // check for support #1
            if (!ContextMenu.isSupported || !root || !dataProvider) {
                return;
            }
            // check for support #2
            var appContextMenu:ContextMenu = new ContextMenu();
            if (!appContextMenu.customItems) {
                return;
            }
            // get current context menu
            if (root.contextMenu) {
                appContextMenu = root.contextMenu;
            }
            // hide all built-in items
            appContextMenu.hideBuiltInItems();
            // add custom items
            const n:int = dataProvider.length;
            for (var i:int = 0; i < n; i++) {
                appContextMenu.customItems.push(ContextMenuItem(dataProvider[i].content));
            }
            // assign to context
            root.contextMenu = appContextMenu;
        }
    
    }
}
}

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
package hu.vpmedia.air {
import air.update.ApplicationUpdaterUI;
import air.update.events.StatusFileUpdateErrorEvent;
import air.update.events.StatusUpdateErrorEvent;
import air.update.events.StatusUpdateEvent;
import air.update.events.UpdateEvent;

import flash.events.ErrorEvent;
import flash.events.Event;

import org.as3commons.logging.api.ILogger;
import org.as3commons.logging.api.getLogger;
import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

/**
 * The class is an AIR only helper class managing application updates.
 */
public final class UpdateServiceUI {
    //----------------------------------
    //  Private Properties
    //----------------------------------

    /**
     * @private
     */
    private var appUpdater:ApplicationUpdaterUI;

    /**
     * @private
     */
    private var updateURL:String;

    //----------------------------------
    //  Public Properties
    //----------------------------------

    /**
     * Checked signal
     */
    public var checked:ISignal = new Signal(Boolean);

    //----------------------------------
    //  Static Properties
    //----------------------------------

    /**
     * @private
     */
    private static const LOG:ILogger = getLogger("UpdateServiceUI");

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function UpdateServiceUI(updateURL:String) {
        this.updateURL = updateURL;
        initialize();
    }

    //----------------------------------
    //  Lifecycle
    //----------------------------------

    /**
     * @private
     */
    private function initialize():void {
        LOG.debug("initialize: " + updateURL);
        appUpdater = new ApplicationUpdaterUI();
        appUpdater.updateURL = updateURL;
        appUpdater.addEventListener(UpdateEvent.INITIALIZED, onUpdateChange, false, 0, true);
        appUpdater.addEventListener(UpdateEvent.CHECK_FOR_UPDATE, onUpdateChange, false, 0, true);
        appUpdater.addEventListener(UpdateEvent.DOWNLOAD_START, onUpdateChange, false, 0, true);
        appUpdater.addEventListener(UpdateEvent.DOWNLOAD_COMPLETE, onUpdateChange, false, 0, true);
        appUpdater.addEventListener(UpdateEvent.BEFORE_INSTALL, onUpdateChange, false, 0, true);
        appUpdater.addEventListener(StatusUpdateEvent.UPDATE_STATUS, onUpdateStatus, false, 0, true);
        appUpdater.addEventListener(ErrorEvent.ERROR, onUpdateError, false, 0, true);
        appUpdater.addEventListener(StatusUpdateErrorEvent.UPDATE_ERROR, onUpdateError, false, 0, true);
        appUpdater.addEventListener(StatusFileUpdateErrorEvent.FILE_UPDATE_ERROR, onUpdateError, false, 0, true);
        appUpdater.isCheckForUpdateVisible = false;
        appUpdater.isDownloadUpdateVisible = true;
        appUpdater.isDownloadProgressVisible = true;
        appUpdater.isInstallUpdateVisible = true;
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * Will start to check for updates
     */
    public function update():void {
        LOG.debug("update: " + appUpdater.currentVersion);
        appUpdater.initialize();
    }

    //----------------------------------
    //  Private methods
    //----------------------------------

    /**
     * @private
     */
    private function onUpdateStatus(event:StatusUpdateEvent):void {
        LOG.debug("onUpdateStatus: " + event);
        checked.dispatch(event.available);
    }

    /**
     * @private
     */
    private function onUpdateChange(event:UpdateEvent):void {
        LOG.debug("onUpdateChange: " + event);
        if (event.type == UpdateEvent.INITIALIZED) {
            appUpdater.checkNow();
        }
    }

    /**
     * @private
     */
    private function onUpdateError(event:Event):void {
        LOG.debug("onUpdateError: " + event);
        checked.dispatch(false);
    }
}
}

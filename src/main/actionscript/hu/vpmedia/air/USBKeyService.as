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

import flash.events.StorageVolumeChangeEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.filesystem.StorageVolume;
import flash.filesystem.StorageVolumeInfo;
import flash.utils.ByteArray;

import org.as3commons.logging.api.ILogger;
import org.as3commons.logging.api.getLogger;
import org.osflash.signals.ISignal;
import org.osflash.signals.Signal;

/**
 * The class provides USB Key based authentication.
 */
public final class USBKeyService {

    //----------------------------------
    //  Public properties
    //----------------------------------

    /**
     * @private
     */
    private var fileName:String;

    /**
     * @private
     */
    private var secret:String;

    /**
     * @private
     */
    private var acl:int;

    /**
     * @private
     */
    public var changed:ISignal = new Signal(int);

    //----------------------------------
    //  Private static properties
    //----------------------------------

    /**
     * @private
     */
    private static const LOG:ILogger = getLogger("USBKeyService");

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * TBD
     */
    public function USBKeyService() {
    }

    //----------------------------------
    //  API - Core
    //----------------------------------

    /**
     * @private
     */
    public function initialize(fileName:String, secret:String):void {
        if (!StorageVolumeInfo.isSupported || this.fileName) {
            return;
        }
        this.fileName = fileName;
        this.secret = secret;
        LOG.debug("initialize");
        StorageVolumeInfo.storageVolumeInfo.addEventListener(StorageVolumeChangeEvent.STORAGE_VOLUME_MOUNT, onStorageChange);
        StorageVolumeInfo.storageVolumeInfo.addEventListener(StorageVolumeChangeEvent.STORAGE_VOLUME_UNMOUNT, onStorageChange);
        update();
    }

    /**
     * TBD
     */
    public function update():void {
        const dpUSB:Vector.<StorageVolume> = StorageVolumeInfo.storageVolumeInfo.getStorageVolumes();
        dpUSB.reverse();
        const n:uint = dpUSB.length;
        for (var i:uint = 0; i < n; i++) {
            if (dpUSB[i].isRemovable) {
                const volume:StorageVolume = dpUSB[i];
                const isUSBKey:Boolean = hasKey(volume);
                LOG.debug("hasKey: " + volume.drive + " => " + isUSBKey);
                if (isUSBKey) {
                    acl = getKeyLevel(volume);
                    changed.dispatch(acl);
                    break;
                }
            }
        }
    }

    //----------------------------------
    //  API - Volume List
    //----------------------------------

    /**
     * @private
     */
    public function getFirstVolume():StorageVolume {
        const dpUSB:Vector.<StorageVolume> = StorageVolumeInfo.storageVolumeInfo.getStorageVolumes();
        dpUSB.reverse();
        const n:uint = dpUSB.length;
        for (var i:uint = 0; i < n; i++) {
            if (dpUSB[i].isRemovable && dpUSB[i].isWritable) {
                const volume:StorageVolume = dpUSB[i];
                return volume;
            }
        }
        return null;
    }

    /**
     * @private
     */
    public function hasVolume():Boolean {
        const dpUSB:Vector.<StorageVolume> = StorageVolumeInfo.storageVolumeInfo.getStorageVolumes();
        dpUSB.reverse();
        const n:uint = dpUSB.length;
        for (var i:uint = 0; i < n; i++) {
            if (dpUSB[i].isRemovable && dpUSB[i].isWritable) {
                return true;
            }
        }
        return false;
    }

    //----------------------------------
    //  API - Volume Item
    //----------------------------------

    /**
     * TBD
     */
    public function hasKey(volume:StorageVolume):Boolean {
        var result:Boolean;
        var file:File = new File(volume.drive + ":\\");
        file = file.resolvePath(fileName);
        if (file.exists && !file.isDirectory) {
            result = true;
        }
        return result;
    }

    /**
     * TBD
     */
    public function getKeyLevel(volume:StorageVolume):int {
        var result:int = 0;
        var file:File = new File(volume.drive + ":\\");
        file = file.resolvePath(fileName);
        if (file.exists && !file.isDirectory) {
            const content:String = readKey(volume);
            if (content == secret) {
                result = 1;
            }
        }
        return result;
    }

    /**
     * TBD
     */
    public function readKey(volume:StorageVolume):String {
        var result:String;
        var file:File = new File(volume.drive + ":\\");
        file = file.resolvePath(fileName);
        if (file.exists && !file.isDirectory) {
            const stream:FileStream = new FileStream();
            stream.open(file, FileMode.READ);
            result = stream.readUTF();
            stream.close();
        }
        return result;
    }

    /**
     * TBD
     */
    public function deleteKey(volume:StorageVolume):void {
        var file:File = new File(volume.drive + ":\\");
        file = file.resolvePath(fileName);
        if (file.exists && !file.isDirectory) {
            file.deleteFile();
            updateACL(volume);
        }
    }

    /**
     * TBD
     */
    public function writeKey(volume:StorageVolume):void {
        var file:File = new File(volume.drive + ":\\");
        file = file.resolvePath(fileName);
        const data:ByteArray = new ByteArray();
        data.writeUTF(secret);
        data.position = 0;
        const stream:FileStream = new FileStream();
        stream.open(file, FileMode.WRITE);
        stream.writeBytes(data);
        stream.close();
        updateACL(volume);
    }

    //----------------------------------
    //  Event Handlers
    //----------------------------------

    /**
     * @private
     */
    private function onStorageChange(event:StorageVolumeChangeEvent):void {
        const volume:StorageVolume = event.storageVolume;
        updateACL(event.type == StorageVolumeChangeEvent.STORAGE_VOLUME_MOUNT ? volume : null);
    }

    /**
     * @private
     */
    private function updateACL(volume:StorageVolume):void {
        const newACL:int = volume ? getKeyLevel(volume) : 0;
        if (acl != newACL) {
            acl = newACL;
            changed.dispatch(acl);
        }
    }


}
}

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
package hu.vpmedia.utils {
import flash.net.LocalConnection;
import flash.system.Capabilities;
import flash.system.Security;
import flash.system.System;

import hu.vpmedia.errors.StaticClassError;

/**
 * Contains reusable methods for System manipulation.
 *
 * @see flash.system.System
 * @see flash.system.Security
 */
public class SystemUtil {

    /**
     * for the Flash Player ActiveX control used by Microsoft Internet Explorer
     */
    public static const PLAYER_ACTIVEX:String = "ActiveX";

    /**
     *  for the Adobe AIR runtime (except for SWF content loaded by an HTML page,
     *  which has Capabilities.playerType set to "PlugIn")
     */
    public static const PLAYER_DESKTOP:String = "Desktop";

    /**
     * for the external Flash Player or in test mode
     */
    public static const PLAYER_EXTERNAL:String = "External";

    /**
     * for the Flash Player browser plug-in (and for SWF content loaded by an HTML page in an AIR application)
     */
    public static const PLAYER_PLUG_IN:String = "PlugIn";

    /**
     * for the stand-alone Flash Player
     */
    public static const PLAYER_STAND_ALONE:String = "StandAlone";

    /**
     * @private
     */
    public function SystemUtil() {
        throw new StaticClassError();
    }

    /**
     * Get host domain
     *
     * @return Host domain
     */
    public static function getDomain():String {
        return new LocalConnection().domain;
    }

    /**
     * Returns the system total memory number in MBs
     *
     * @return Float
     */
    public static function getTotalMemoryMB():Number {
        return Number((System.totalMemoryNumber * 0.000000954).toFixed(3));
    }

    /**
     * Returns the private memory number in MBs
     *
     * @return Float
     */
    public static function getPrivateMemoryMB():Number {
        return Number((System.privateMemory * 0.000000954).toFixed(3));
    }

    /**
     * Returns the free memory number in MBs
     *
     * @return Float
     */
    public static function getFreeMemoryMB():Number {
        return Number((System.freeMemory * 0.000000954).toFixed(3));
    }

    /**
     * Allow list of domains
     */
    public static function allowDomains(list:Array):void {
        var n:int = list.length;
        var i:int;
        for (i = 0; i < n; i++) {
            Security.allowDomain(list[i]);
        }
    }

    /**
     * Check for local debug sandbox type
     *
     * @return Boolean
     */
    public static function isLocalSandbox():Boolean {
        var isLocalTrusted:Boolean = Security.sandboxType == Security.LOCAL_TRUSTED;
        var isStandAlone:Boolean = Capabilities.playerType == PLAYER_STAND_ALONE;
        return isLocalTrusted && isStandAlone;
    }

    /**
     * Call Garbage Collector
     */
    public static function gc():void {
        // mark & sweep
        System.pauseForGCIfCollectionImminent(0);
        System.pauseForGCIfCollectionImminent(0);
        // Call debugger supported GC
        try {
            // mark & sweep
            System.gc();
            System.gc();
        } catch (error:Error) {
        }
        // unsupported hack that seems to force a *full* GC
        try {
            var lc1:LocalConnection = new LocalConnection();
            var lc2:LocalConnection = new LocalConnection();
            lc1.connect('name');
            lc2.connect('name');
        } catch (error:Error) {
        }
    }
}
}

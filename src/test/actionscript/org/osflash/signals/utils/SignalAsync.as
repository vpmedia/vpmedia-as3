package org.osflash.signals.utils {
import flash.events.EventDispatcher;

import org.osflash.signals.ISignal;

/**
 * Utility call to test objects that has signals.
 *
 * @author eidiot
 */
public class SignalAsync extends EventDispatcher {
    //======================================================================
    //  Constructor
    //======================================================================
    /**
     * Construct a <code>SignalAsync</code>.
     */
    public function SignalAsync(signal:ISignal) {
        signal.addOnce(onCalled);
    }

    //======================================================================
    //  Callbacks
    //======================================================================
    private function onCalled(a:* = null, b:* = null, c:* = null, d:* = null, e:* = null, f:* = null, g:* = null, h:* = null):void {
        dispatchEvent(new SignalAsyncEvent(SignalAsyncEvent.CALLED, arguments));
    }
}
}
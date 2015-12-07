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
package hu.vpmedia.media {
import flash.display.BitmapData;
import flash.display.Stage;
import flash.system.Security;
import flash.system.SecurityPanel;

/**
 * TBD
 */
public class DevicePrivacyEnforcer {
    private var stage:Stage;

    public function DevicePrivacyEnforcer(stage:Stage) {
        this.stage = stage;
    }

    public function forcePanelOpen():void {
        if (!isSecurityPanelOpen())
            Security.showSettings(SecurityPanel.PRIVACY);
    }

    public function isSecurityPanelOpen():Boolean {
        var result:Boolean = false;
        var dummy:BitmapData = new BitmapData(1, 1);
        try {
            // Try to capture the stage: Security error occures if settings dialog box is open
            dummy.draw(stage);
        } catch (e:Error) {
            trace(this, e);
            result = true;
        } finally {
            dummy.dispose();
            dummy = null;
        }
        return result;
    }
}
}

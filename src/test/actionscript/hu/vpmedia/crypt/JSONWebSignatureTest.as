/*
 * =BEGIN CLOSED LICENSE
 *
 * Copyright (c) 2013 Andras Csizmadia
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

package hu.vpmedia.crypt {
import flash.display.Sprite;

import org.flexunit.Assert;

public class JSONWebSignatureTest extends Sprite {
    public function JSONWebSignatureTest() {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Before and After
    //
    //--------------------------------------------------------------------------

    [Before]
    public function runBeforeEveryTest():void {
        // implement
    }

    [After]
    public function runAfterEveryTest():void {
        // implement
    }

    //--------------------------------------------------------------------------
    //
    //  Tests
    //
    //--------------------------------------------------------------------------

    [Test]
    public function encode_decode_test():void {
        var source:Object = { user: { id: "12345", name: "TEST", time: 1000 }};
        var request:String = JSONWebSignature.encode(source, "TEST_KEY_12345");
        var response:Object = JSONWebSignature.decode(request, "TEST_KEY_12345");
        Assert.assertNotNull(response);
        Assert.assertEquals(response.user.id, "12345");
        Assert.assertEquals(response.user.time, 1000);
        Assert.assertEquals(response.user.name, "TEST");
    }
}
}

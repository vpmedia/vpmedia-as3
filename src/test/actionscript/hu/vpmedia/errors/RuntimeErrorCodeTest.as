/*
 * =BEGIN CLOSED LICENSE
 *
 *  Copyright (c) 2015 Docmet Systems
 *  http://www.docmet.com
 *
 *  For information about the licensing and copyright please
 *  contact us at info@docmet.com
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 *
 * =END CLOSED LICENSE
 */

package hu.vpmedia.errors {
import org.flexunit.Assert;

public class RuntimeErrorCodeTest {

    public function RuntimeErrorCodeTest() {
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
    public function test_nullReason():void {
        Assert.assertNull(RuntimeErrorCode.getErrorMessage("999999"));
    }

    [Test]
    public function test_validReason():void {
        Assert.assertEquals(RuntimeErrorCode.getErrorMessage("1000"), "The system is out of memory.");
    }

}
}

/*
 * =BEGIN CLOSED LICENSE
 *
 *  Copyright (c) 2014 Andras Csizmadia
 *  http://www.vpmedia.eu
 *
 *  For information about the licensing and copyright please
 *  contact us at info@vpmedia.eu
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

package hu.vpmedia.utils {
import flexunit.framework.Assert;

public class CurrencyUtilTest {
    [Before]
    public function setUp():void {
    }

    [After]
    public function tearDown():void {
    }

    [Test]
    public function test_formatNumber():void {
        CurrencyUtil.fractionalDigits = 2;
        Assert.assertEquals(CurrencyUtil.formatNumber(1), "1.00");
    }
}
}

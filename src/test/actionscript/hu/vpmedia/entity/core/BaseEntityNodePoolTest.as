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

package hu.vpmedia.entity.core {
import org.hamcrest.assertThat;
import org.hamcrest.core.isA;
import org.hamcrest.core.not;
import org.hamcrest.object.sameInstance;

public class BaseEntityNodePoolTest {
    private var objectPool:BaseEntityNodePool;

    public function BaseEntityNodePoolTest() {
    }

    //--------------------------------------------------------------------------
    //
    //  Before and After
    //
    //--------------------------------------------------------------------------

    [Before]
    public function runBeforeEveryTest():void {
        objectPool = new BaseEntityNodePool(BaseEntityNode);
    }

    [After]
    public function runAfterEveryTest():void {
        objectPool.dispose();
    }

    //--------------------------------------------------------------------------
    //
    //  Tests
    //
    //--------------------------------------------------------------------------

    [Test]
    public function getRetrievesObjectOfAppropriateClass():void {
        assertThat(BaseEntityNode(objectPool.checkOut()), isA(BaseEntityNode));
    }

    [Test]
    public function disposedComponentsAreRetrievedByGet():void {
        var mockComponent:BaseEntityNode = new BaseEntityNode();
        objectPool.checkOut(); // needs to free space in the pool (behaviour should changed later..)
        objectPool.checkIn(mockComponent);
        var retrievedComponent:BaseEntityNode = objectPool.checkOut();
        assertThat(retrievedComponent, sameInstance(mockComponent));
    }

    [Test]
    public function emptyPreventsRetrievalOfPreviouslyDisposedComponents():void {
        var mockComponent:BaseEntityNode = new BaseEntityNode();
        objectPool.checkIn(mockComponent);
        objectPool.dispose();
        var retrievedComponent:BaseEntityNode = objectPool.checkOut();
        assertThat(retrievedComponent, not(sameInstance(mockComponent)));
    }
}
}
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
package hu.vpmedia.entity.twoD.ai {
import hu.vpmedia.entity.core.BaseEntityComponent;
import hu.vpmedia.math.Vector2D;

/**
 * TBD
 * @see com.lookbackon.AI.steeringBehavior.*
 */
public class BoidObstacleComponent extends BaseEntityComponent {

    public var radius:Number;

    public var position:Vector2D;

    public function BoidObstacleComponent(parameters:Object = null) {
        super(parameters);
    }

    override protected function setupDefaults():void {
        radius = 10;
        position = new Vector2D();
    }
}
}

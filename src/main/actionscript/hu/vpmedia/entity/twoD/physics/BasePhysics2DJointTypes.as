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
package hu.vpmedia.entity.twoD.physics {
import hu.vpmedia.errors.StaticClassError;

/**
 * TBD
 */
public class BasePhysics2DJointTypes {

    /**
     * TBD
     */
    public static const DISTANCE:String = "Distance";

    /**
     * TBD
     */
    public static const LINE:String = "Line";

    /**
     * TBD
     */
    public static const MOUSE:String = "Mouse";

    /**
     * TBD
     */
    public static const PRISMATIC:String = "Prismatic";

    /**
     * TBD
     */
    public static const PULLEY:String = "Pulley";

    /**
     * TBD
     */
    public static const REVOLUTE:String = "Revolute";

    /**
     * TBD
     */
    public static const WELD:String = "Weld";

    /**
     * TBD
     */
    public static const ROPE:String = "Rope";

    /**
     * TBD
     */
    public static const FRICTION:String = "Friction";

    /**
     * TBD
     */
    public static const GEAR:String = "Gear";

    /**
     * TBD
     */
    public function BasePhysics2DJointTypes() {
        throw new StaticClassError();
    }
}
}

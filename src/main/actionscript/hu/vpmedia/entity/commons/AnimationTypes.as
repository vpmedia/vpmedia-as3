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
package hu.vpmedia.entity.commons {
import hu.vpmedia.errors.StaticClassError;

/**
 * TBD
 */
public class AnimationTypes {

    public static const DEFAULT:String = "default";

    public static const IDLE:String = "default";

    public static const BUSY:String = "busy";

    public static const BORN:String = "born";

    public static const WALK:String = "walk";

    public static const JUMP:String = "jump";

    public static const DUCK:String = "duck";

    public static const SHOOT:String = "shoot";

    public static const HURT:String = "hurt";

    public static const DIE:String = "die";

    public static const HEAL:String = "heal";

    /**
     * TBD
     */
    public function AnimationTypes() {
        throw new StaticClassError();
    }
}
}

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
public class SystemTypes {
    public static const PRE_UPDATE:int = 1;
    public static const UPDATE:int = 2;
    public static const POST_UPDATE:int = 3;
    public static const RESOLVE_COLLISIONS:int = 4;
    public static const PRE_RENDER:int = 5;
    public static const RENDER:int = 6;
    public static const POST_RENDER:int = 7;

    public function SystemTypes() {
        throw new StaticClassError();
    }
}
}

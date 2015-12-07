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

/**
 * Box2D uses bits to represent collision categories.
 */
public class BasePhysics2DCollisionCategories {
    private static var _allCategories:uint = 0;

    private static var _numCategories:uint = 0;

    private static var _categoryIndexes:Array = [ 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384 ];

    private static var _categoryNames:Object = {};

    public static const CATEGORY_FRIEND:String = "friend";

    public static const CATEGORY_FOE:String = "foe";

    public static const CATEGORY_LEVEL:String = "level";

    public static const CATEGORY_GEM:String = "gem";

    public static function setDefaults():void {
        add(CATEGORY_FRIEND);
        add(CATEGORY_FOE);
        add(CATEGORY_LEVEL);
        add(CATEGORY_GEM);
    }

    /**
     * Returns true if the categories in the first parameter contain the category(s) in the second parameter.
     * @param    categories The categories to check against.
     * @param    theCategory The category you want to know exists in the categories of the first parameter.
     */
    public static function has(categories:uint, theCategory:uint):Boolean {
        return Boolean(categories & theCategory);
    }

    /**
     * Add a category to the collision categories list.
     * @param    categoryName The name of the category.
     */
    public static function add(categoryName:String):void {
        if (_numCategories == 15) {
            throw new Error("You can only have 15 categories.");
            return;
        }
        if (_categoryNames[categoryName])
            return;
        _categoryNames[categoryName] = _categoryIndexes[_numCategories];
        _allCategories |= _categoryIndexes[_numCategories];
        _numCategories++;
    }

    /**
     * Gets the category(s) integer by name. You can pass in multiple category names, and it will return the appropriate integer.
     * @param    ...args The categories that you want the integer for.
     * @return A signle integer representing the category(s) you passed in.
     */
    public static function get(...args):uint {
        var categories:uint = 0;
        for each (var name:String in args) {
            var category:uint = _categoryNames[name];
            if (category == 0) {
                trace("Warning: " + name + " category does not exist.");
                continue;
            }
            categories |= _categoryNames[name];
        }
        return categories;
    }

    /**
     * Returns an integer representing all categories.
     */
    public static function getAll():uint {
        return _allCategories;
    }

    /**
     * Returns an integer representing all categories except the ones whose names you pass in.
     * @param    ...args The names of the categories you want excluded from the result.
     */
    public static function getAllExcept(...args):uint {
        var categories:uint = _allCategories;
        for each (var name:String in args) {
            var category:uint = _categoryNames[name];
            if (category == 0) {
                trace("Warning: " + name + " category does not exist.");
                continue;
            }
            categories &= (~_categoryNames[name]);
        }
        return categories;
    }

    /**
     * Returns the number zero, which means no categories. You can also just use the number zero instead of this function (but this reads better).
     */
    public static function getNone():uint {
        return 0;
    }
}
}

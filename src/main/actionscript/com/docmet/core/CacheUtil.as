/*
 * =BEGIN CLOSED LICENSE
 *
 *  Copyright (c) 2013 Docmet Systems
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

package com.docmet.core {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display3D.Context3DTextureFormat;
import flash.media.Sound;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

import hu.vpmedia.errors.StaticClassError;

import starling.textures.Texture;
import starling.textures.TextureAtlas;

/**
 * Contains reusable methods for data caching operations.
 */
public final class CacheUtil {
    //----------------------------------
    //  Private static properties
    //----------------------------------

    /**
     * @private
     */
    private static var _dataProvider:Dictionary = new Dictionary(false);

    /**
     * @private
     *
     * Special Bundle and not part of dictionaries list.
     */
    private static var _textures:Dictionary = new Dictionary(false);

    /**
     * @private
     *
     * Special Bundle and not part of dictionaries list.
     */
    private static var _runtimeTextures:Dictionary = new Dictionary(false);

    //----------------------------------
    //  Public static constants
    //----------------------------------

    /**
     * AddItem Skip strategy (default)
     */
    public static const STRATEGY_SKIP:uint = 1;

    /**
     * AddItem Overwrite strategy
     */
    public static const STRATEGY_OVERWRITE:uint = 2;

    //----------------------------------
    //  Public static properties
    //----------------------------------

    /**
     * Global texture scale factor
     */
    public static var contentScaleFactor:Number = 1;

    /**
     * The last texture id an app. tried to retrieve.
     * Used to debug Texture not found errors.
     */
    public static var lastTextureId:String;

    /**
     * AddItem duplicate strategy
     */
    public static var duplicateStrategy:uint = 1;

    //----------------------------------
    //  Constructor (private)
    //----------------------------------

    /**
     * @private
     */
    public function CacheUtil() {
        throw new StaticClassError();
    }

    //----------------------------------
    //  Common
    //----------------------------------

    /**
     * Add an item to the cache map.
     */
    public static function addItem(id:String, data:*):void {
        if (hasItem(id) && duplicateStrategy == STRATEGY_SKIP) {
            return;
        }
        if (data is Bitmap) {
            _dataProvider[id] = data.bitmapData;
        } else {
            _dataProvider[id] = data;
        }
    }

    /**
     * Check existing item by id.
     */
    public static function hasItem(id:String):Boolean {
        return _dataProvider.hasOwnProperty(id);
    }

    /**
     * Removes a cached item with the specified name.
     */
    public static function removeItem(id:String):void {
        _dataProvider[id] = null;
        if (_dataProvider[id] is BitmapData) {
            BitmapData(_dataProvider[id]).dispose();
        }
        delete _dataProvider[id];
    }

    //----------------------------------
    //  Graphics
    //----------------------------------

    /**
     * Returns a cached BitmapData item with the specified name.
     */
    public static function getBitmapData(id:String):BitmapData {
        return _dataProvider[id];
    }

    /**
     * Returns a cached Bitmap item with the specified name.
     */
    public static function getBitmap(id:String):Bitmap {
        if (!_dataProvider[id]) {
            return null;
        }
        return new Bitmap(_dataProvider[id]);
    }

    /**
     * Returns a cached Texture item with the specified name.
     */
    public static function getTexture(id:String, isDisposeLater:Boolean = false):Texture {
        if (isDisposeLater)
            return getTextureByDP(id, _runtimeTextures);
        return getTextureByDP(id, _textures);
    }

    /**
     * Returns a cached TextureAtlas item with the specified name.
     */
    public static function getTextureAtlas(id:String, isDisposeLater:Boolean):TextureAtlas {
        // get file names
        const atfId:String = id.split(".png").join(".atf");
        const atlasId:String = id.split(".png").join(".atl");
        const xmlId:String = id.split(".png").join(".xml");
        // check for non available texture
        if (!hasItem(id) && !hasItem(atfId))
            return null;
        // check for saved
        if (isDisposeLater && _runtimeTextures[atlasId])
            return _runtimeTextures[atlasId];
        else if (_textures[atlasId])
            return _textures[atlasId];
        // create
        const texture:Texture = getTexture(id, isDisposeLater);
        const xml:XML = CacheUtil.getXML(xmlId);
        const atlas:TextureAtlas = new TextureAtlas(texture, xml);
        // save created
        if (isDisposeLater)
            _runtimeTextures[atlasId] = atlas;
        else
            _textures[atlasId] = atlas;
        // return created
        return atlas;
    }

    /**
     * Clears all runtime Texture items.
     */
    public static function clearRuntimeTextures():uint {
        var count:uint = 0;
        for (var key:String in _runtimeTextures) {
            if (_runtimeTextures[key] is TextureAtlas) {
                TextureAtlas(_runtimeTextures[key]).dispose();
            } else {
                Texture(_runtimeTextures[key]).dispose();
            }
            _runtimeTextures[key] = null;
            delete _runtimeTextures[key];
            count++;
        }
        return count;
    }

    //----------------------------------
    //  Various strict type getter APIs
    //----------------------------------

    /**
     * Returns a Sound item with the specified name.
     */
    public static function getSound(id:String):Sound {
        return _dataProvider[id];
    }

    /**
     * Returns a XML item with the specified name.
     */
    public static function getXML(id:String):XML {
        return _dataProvider[id];
    }

    /**
     * Returns a JSON item with the specified name.
     */
    public static function getJSON(id:String):Object {
        return _dataProvider[id];
    }

    /**
     * Returns a Text item with the specified name.
     */
    public static function getText(id:String):String {
        return _dataProvider[id];
    }

    /**
     * Returns a Binary item with the specified name.
     */
    public static function getBinary(id:String):ByteArray {
        return _dataProvider[id];
    }

    //----------------------------------
    //  Lifecycle
    //----------------------------------

    /**
     * Disposes the all cache maps.
     */
    public static function dispose():void {
        disposeDict(_dataProvider, true);
        disposeDict(_textures, true);
        disposeDict(_runtimeTextures, true);
    }

    //----------------------------------
    //  Private Helpers
    //----------------------------------

    /**
     * @private
     */
    private static function disposeDict(dictionary:Dictionary, isRecreate:Boolean):void {
        for (var key:String in dictionary) {
            dictionary[key] = null;
            delete dictionary[key];
        }
        if (isRecreate)
            dictionary = new Dictionary(false);
    }

    /**
     * @private
     */
    private static function getTextureByDP(id:String, dp:Dictionary):Texture {
        lastTextureId = id;
        var result:Texture = null;
        if (!dp[id]) {
            const atfId:String = id.split(".png").join(".atf");
            if (hasItem(atfId)) {
                result = Texture.fromAtfData(getBinary(atfId), contentScaleFactor, false);
                dp[id] = result;
            } else if (hasItem(id)) {
                result = Texture.fromBitmapData(getBitmapData(id), true, false, contentScaleFactor, Context3DTextureFormat.BGRA);
                dp[id] = result;
            }
        } else {
            result = dp[id];
        }
        return result;
    }
}
}

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
package hu.vpmedia.serializers {
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

/**
 * TBD
 */
public class Serializer implements ISerializer {

    /**
     * @private
     */
    private var _encoderMap:Dictionary;

    /**
     * @private
     */
    private var _typeMap:Dictionary;

    /**
     * @private
     */
    private static const GENERIC:String = "*";

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function Serializer() {
        _encoderMap = new Dictionary();
        _typeMap = new Dictionary();
        addSerializer(GenericSerializer);
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * TBD
     */
    public function addSerializer(encoder:Class):Boolean {
        var description:EncoderDescription = new EncoderDescription(encoder);
        if (description.isError)
            throw new Error(description.errorDescription);
        var type:String = description.type;
        if (_typeMap[type] != null)
            throw new Error("Custom encoder collision - you cannot define two custom encoders for " + type);
        var instance:Object = new encoder(this);
        _encoderMap[encoder] = new EncoderReference(type, instance);
        _typeMap[type] = instance;
        return !description.isError;
    }

    /**
     * TBD
     */
    public function removeSerializer(encoder:Class):Boolean {
        var reference:EncoderReference = _encoderMap[encoder];
        if (!reference)
            return false;
        delete _encoderMap[encoder];
        delete _typeMap[reference.type];
        return true;
    }

    /**
     * TBD
     */
    public function getSerializerByType(type:String):Object {
        return _typeMap[type];
    }

    /**
     * TBD
     */
    public function encode(source:*):Object {
        var qcn:String = getQualifiedClassName(source);
        var serializer:Object = getSerializerByType(qcn);
        if (!serializer) {
            serializer = getSerializerByType(GENERIC);
        }
        var result:Object = serializer.encode(source);
        return result;
    }

    /**
     * TBD
     */
    public function decode(source:Object):* {
        var serializer:Object;
        if (source.hasOwnProperty("__type")) {
            serializer = getSerializerByType(source.__type);
            if (serializer) {
                return serializer.decode(source.__value ? source.__value : source);
            }
            else {
                serializer = getSerializerByType(GENERIC);
                return serializer.decode(source);
            }
        }
        var qcn:String = getQualifiedClassName(source);
        serializer = getSerializerByType(qcn);
        var result:* = serializer.decode(source);
        return result;
    }
}
}

//----------------------------------
//  Private classes
//----------------------------------

import flash.utils.describeType;

/**
 * TBD
 */
class EncoderReference {

    //----------------------------------
    //  Public properties
    //----------------------------------

    /**
     * TBD
     */
    public var type:String;

    /**
     * TBD
     */
    public var instance:Object;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function EncoderReference(type:String, instance:Object) {
        this.type = type;
        this.instance = instance;
    }
}

/**
 * TBD
 */
class EncoderDescription {

    //----------------------------------
    //  Public properties
    //----------------------------------

    /**
     * TBD
     */
    public var isError:Boolean;

    /**
     * TBD
     */
    public var errorDescription:String;

    /**
     * TBD
     */
    public var type:String;

    //----------------------------------
    //  Constructor
    //----------------------------------

    /**
     * Constructor
     */
    public function EncoderDescription(klass:Class) {
        var description:XML = describeType(klass);
        var encoder:XML = description..method.(@name == "encode")[0];
        if (!encoder || encoder.parameter.length() != 1 || encoder.@returnType != "Object") {
            errorDescription = "Unable to create encoder from class - an encoder needs a public function encode(Type):Object";
            isError = true;
            return;
        }
        var decoder:XML = description..method.(@name == "decode")[0];
        if (!decoder || decoder.parameter.length() != 1 || decoder.parameter.@type != "Object") {
            errorDescription = "Unable to create encoder from class - an encoder needs a public function decode(Object):Type";
            isError = true;
            return;
        }
        type = encoder.parameter.@type;
        if (decoder.@returnType != type) {
            errorDescription = "Unable to create encoder from class - the encoder's type doesn't match the decoder's return type";
            isError = true;
            return;
        }
    }
}

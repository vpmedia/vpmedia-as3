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
package hu.vpmedia.net {
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;

import hu.vpmedia.framework.BaseConfig;
import hu.vpmedia.utils.ObjectUtil;

import org.as3commons.logging.api.ILogger;
import org.as3commons.logging.api.getLogger;

/**
 * TBD
 */
public class ServiceManager extends BaseTransmitter {

    /**
     * TBD
     */
    private static const LOG:ILogger = getLogger("ServiceManager");

    /**
     * TBD
     */
    public static const SERVICE_CALL:String = "serviceCall";

    /**
     * TBD
     */
    protected var _registeredServiceProviders:Dictionary;

    /**
     * TBD
     */
    protected var _urlPrefix:String = "";

    /**
     * TBD
     */
    protected var _assetPrefix:String = "";

    /**
     * TBD
     */
    protected var _dict:Dictionary;

    /**
     * TBD
     */
    public function ServiceManager() {
        _registeredServiceProviders = new Dictionary(false);
        _dict = new Dictionary(false);
        super();
    }

    //----------------------------------
    //  API
    //----------------------------------

    /**
     * TBD
     */
    public function getService(id:String):BaseTransmitter {
        LOG.debug("getService: " + id);
        return _dict[id];
    }

    /*public function getServices():Vector.<IBaseService>
     {
     var result:Vector.<IBaseService>=new Vector.<IBaseService>();
     for (var p:String in _dict)
     {
     result.push(_dict[p]);
     }
     return result;
     }*/

    /**
     * TBD
     */
    public function getServiceNames():Vector.<String> {
        var result:Vector.<String> = new Vector.<String>();
        for (var p:String in _dict) {
            result.push(p);
        }
        return result;
    }

    /**
     * TBD
     */
    public function addService(service:BaseTransmitter, id:String):void {
        LOG.debug("addService: " + service + " => " + id);
        //trace(this, "addService", id, service);
        _dict[id] = service;
    }

    /**
     * TBD
     */
    public function removeService(id:String):void {
        LOG.debug("removeService: " + id);
        _dict[id] = null;
        delete _dict[id];
    }

    /**
     * TBD
     */
    public function setUrlPrefix(value:String):void {
        LOG.debug("setUrlPrefix: " + value);
        _urlPrefix = value;
    }

    /**
     * TBD
     */
    public function setAssetPrefix(value:String):void {
        LOG.debug("setAssetPrefix: " + value);
        _assetPrefix = value;
    }

    /**
     * TBD
     */
    public function loadXML(xml:XML):void {
        var xmlString:String = String(xml);
        xmlString = xmlString.split("[STATIC_DOMAIN]").join(_assetPrefix);
        xml = XML(xmlString);
        var xmlList:XMLList = xml..servicelocator.item;
        var prefix:String = _urlPrefix + xml..servicelocator.@prefix;
        var n:int = xmlList.length();
        var config:BaseConfig;
        var service:BaseTransmitter;
        for (var i:int = 0; i < n; i++) {
            var serviceClassName:String = xmlList[i].@serviceClass;
            var configClassName:String = xmlList[i].@configClass;
            var serviceClass:Class = Class(getDefinitionByName(serviceClassName));
            var configClass:Class = Class(getDefinitionByName(configClassName));
            var configList:XMLList = xmlList[i].config.children();
            var params:Object = {};
            var m:int = configList.length();
            for (var j:int = 0; j < m; j++) {
                var name:String = configList[j].name();
                if (name == "url" && xmlList[i].config.@noPrefix != true) {
                    params[name] = prefix + configList[j];
                }
                else {
                    params[name] = configList[j];
                }
                // trace(i,j,name,params[name]);
            }
            config = new configClass(params);
            service = new serviceClass(config);
            addService(service, params.name);
            service.signal.add(serviceHandler);
        }
    }

    /**
     * TBD
     */
    public function registerServiceProvider(baseClass:Class, configClass:Class):void {
        LOG.debug("registerServiceProvider: " + baseClass + " => " + configClass);
        _registeredServiceProviders[baseClass] = configClass;
    }

    //----------------------------------
    //  Event handlers
    //----------------------------------

    /**
     * TBD
     */
    private function serviceHandler(medium:BaseTransmission):void {
        //LOG.debug("serviceHandler: " + medium);
        signal.dispatch(medium);
    }

    //----------------------------------
    //  API
    //----------------------------------
    /*public function load(serviceName:String, params:Object=null):void
     {
     var service:IBaseTransmitter=getService(serviceName);
     sendTransmission(SERVICE_CALL, params, serviceName, service);
     var loaderService:HTTPLoader=HTTPLoader(service);
     loaderService.execute();
     }*/

    /**
     * TBD
     */
    public function send(serviceName:String, params:Object = null):void {
        LOG.debug("send: " + serviceName);
        ObjectUtil.deepTrace(params);
        var service:BaseTransmitter = getService(serviceName);
        sendTransmission(SERVICE_CALL, params, serviceName, service);
        var httpService:HTTPConnection = HTTPConnection(service);
        httpService.send(params);
    }
}
}

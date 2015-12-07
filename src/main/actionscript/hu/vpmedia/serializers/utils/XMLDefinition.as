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

package hu.vpmedia.serializers.utils {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.utils.describeType;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

/**
 * The XMLDefinition class contains static methods for working
 * with XML-based definitions.  XML-based definitions are XML
 * structures which mimic object relationships in Flash.
 * <br /><br />
 * There are 3 kinds of elements and 1 attribute for special uses, each
 * of which defined in the com.senocular.xml.XMLDefinition namespace.
 * They are:
 * <ul>
 *     <li>property (element)</li>
 *     <li>call (element)</li>
 *     <li>arguments (element)</li>
 *     <li>name (attribute)</li>
 * </ul>
 * The property element is used to access an existing property of an
 * object.  For example, you may want to reference the transform property
 * of a MovieClip instance defined in XML rather than redefine it.  In
 * that case you would use the property element to access that property's
 * existing value rather than provide a new value to be set for the
 * MovieClip's transform property.  This element uses one attribute, name,
 * to determine the name of the property being accessed.
 * <br /><br />
 * The call element is used to call methods within objects. Like the
 * property element, it too uses the name attribute to identify the class
 * member (in this case a method) to be accessed.  This would be useful
 * for calling drawing methods on a display object.  Method arguments
 * are handled through the arguments element.
 * <br /><br />
 * The arguments element is used in combination with class definitions
 * or method calls.  For class definitions (elements representing class
 * instances) the arguments element contains the arguments for that
 * instance's constructor call.  For method calls, the arguments element's
 * children are used as arguments for that method. The definitions within
 * an arguments block is scoped to the parent node of the arguments
 * element so references to property in an arguments element will reference
 * properties in the argument's parent object. One caveat concerning the
 * arguments element is that you are limited to 10 or less arguments.
 * <br /><br />
 * The name attribute is used to identify the property name of the
 * current object as it exists within its parent.  For example, every
 * movie clip has a Transform instance stored within its transform
 * property.  The property name "transform" represents the name that
 * the Transform object would use in XML to associate itself with the
 * transform property of it's parent object.  For XML nodes defined
 * in the definition namespace, the name property doesn't also have to
 * be within the same namespace; it can be without a namespace.
 * <br /><br />
 * The following example creates a Sprite a line drawn in its graphics
 * object and one Shape child object with the instance name "child":<br />
 * <pre><code>
 * var definition:XML =
 * &lt;display:Sprite x="50" y="100"
 *     xmlns:display="flash.display"
 *     xmlns:def="com.senocular.xml.XMLDefinition"&gt;
 *     &lt;display:Shape /&gt;
 *     &lt;def:property def:name="graphics"&gt;
 *         &lt;def:call def:name="lineStyle"&gt;
 *             &lt;def:arguments&gt;
 *                 &lt;Number&gt;1&lt;/Number&gt;
 *                 &lt;uint&gt;0xFF0000&lt;/uint&gt;
 *             &lt;/def:arguments&gt;
 *         &lt;/def:call&gt;
 *         &lt;def:call name="lineTo"&gt;
 *             &lt;def:arguments&gt;
 *                 &lt;Number&gt;100&lt;/Number&gt;
 *                 &lt;Number&gt;100&lt;/Number&gt;
 *             &lt;/def:arguments&gt;
 *         &lt;/def:call&gt;
 *     &lt;/def:property&gt;
 * &lt;/display:Sprite&gt;;
 * var sprite:Sprite = XMLDefinition.parse(definition);
 * </code></pre>
 *
 * <!-- Non-character entity version:
 * var definition:XML =
 * <display:Sprite x="50" y="100"
 *     xmlns:display="flash.display"
 *     xmlns:def="com.senocular.xml.XMLDefinition">
 *     <display:Shape />
 *     <def:property def:name="graphics">
 *         <def:call def:name="lineStyle">
 *             <def:arguments>
 *                 <Number>1</Number>
 *                 <uint>0xFF0000</uint>
 *             </def:arguments>
 *         </def:call>
 *         <def:call name="lineTo">
 *             <def:arguments>
 *                 <Number>100</Number>
 *                 <Number>100</Number>
 *             </def:arguments>
 *         </def:call>
 *     </def:property>
 * </display:Sprite>;
 * var sprite:Sprite = XMLDefinition.parse(definition);
 * -->
 */
public class XMLDefinition {
    private static var defaultFilter:XMLDefinitionFilter;

    /**
     * The namespace used to indicate special nodes (property, call, arguments,
     * name) in the XML definition. Its prefix is "def" and its uri is
     * "com.senocular.xml.XMLDefinition".
     */
    public static function get namespace():Namespace {
        return new Namespace(def.prefix, def.uri);
    }

    private static var def:Namespace = new Namespace("def", "hu.vpmedia.xml.XMLDefinition");
    private static var types:Object;
    private static var namespaces:Object;
    private static var namespaceCount:int = 0;
    private static var filterHash:Object;

    /**
     * Creates a definition XML from a target object. To limit the
     * number of properties that can be returned with the resulting
     * XML, an array of XMLDefinitionFilter instances can be used to
     * determine, by type, which properties are included.  The resulting
     * XML object can be used with XMLDefinition.parse to recreate
     * the original object.
     * <br /><br />
     * Namespaces for the XML returned are automatically named using
     * an incrementing numeric suffix following "ns" for all namespaces
     * except the definition namespace (used for definitions specific
     * to the XMLDefinition class) which instead uses the prefix "def".
     * @param target The target object from which a definition XML
     *         object is generated.
     * @param xmlParent The XML node in which the resulting XML is
     *         inserted.
     * @param filters An array of XMLDefinitionFilter instances that
     *         define the makeup of XML nodes for different types.
     * @param name The value of the name attribute that defines the
     *         property name in the parent object.
     * @param isProperty When true, this indicates that the current
     *         XML node should be created as a property. This is usually
     *         indicated internally based on a filter.  If isProperty is
     *         true, it is assumed that name is also provided.
     * @return An XML instance dscribing the target object and its
     *        properties and children as a definition XML instance.
     */
    public static function create(target:Object, xmlParent:XML = null, filters:Array = null, name:String = "", isProperty:Boolean = false):XML {
        // iteration variables
        var n:int;
        var i:int;
        var p:String;
        // parsed object types
        var firstCall:Object;
        if (!types) {
            // first external call, define types
            // to be used for all recursive calls
            types = {};
            // lookup for type namespaces
            namespaces = {};
            namespaceCount = 0;
            // define a filter hash for a quicker
            // lookup of filters and properties
            filterHash = {};
            if (filters) {
                i = filters.length;
                var filteri:XMLDefinitionFilter;
                while (i--) {
                    filteri = XMLDefinitionFilter(filters[i]);
                    filterHash[filteri.qualifiedClassName] = filteri;
                }
            }
            firstCall = types;
        }
        // the current target's definition
        var definition:XML;
        // parse class name
        var typeQName:String = getQualifiedClassName(target);
        var parts:Array = typeQName.split("::");
        var typeName:String;
        var typePath:String;
        var currentNamespace:Namespace;
        if (parts.length == 2) {
            typePath = parts[0];
            typeName = parts[1];
            // define namespace based on pacakage path of definition
            if (typePath in namespaces == false) {
                namespaceCount++;
                namespaces[typePath] = new Namespace("ns" + namespaceCount, typePath);
            }
            currentNamespace = namespaces[typePath];
        }
        else {
            // global (no package)
            typeName = parts[0];
        }
        // get the current type definition for this object
        // from the types list; if not present, define
        if (typeQName in types == false) {
            types[typeQName] = describeType(target);
        }
        var typeDefinition:XML = types[typeQName];
        // validate object; if the constructor requires arguments
        // they cannot be assumed; return null unless a property
        if (!isProperty && typeDefinition.constructor.parameter.@optional[0] == "false") {
            return null;
        }
        // get the filter for this object type
        var currentFilter:Object = filterHash[typeQName];
        // check to see if the target is a property. If so
        // define XML as a property XML node
        if (isProperty) {
            if (!name) {
                // properties require a name, if
                // not provided, return null
                return null;
            }
            definition = <def:Property def:name={name} xmlns:def={def.uri} />;
            // add the definition namespace to
            // the namespaces list to be included
            // with the root XML node
            if (def.uri in namespaces == false) {
                namespaces[def.uri] = def;
            }
        }
        else {
            // set up as normal XML node for this object
            definition = <{typeName} />;
            if (currentNamespace) {
                definition.setNamespace(currentNamespace);
            }
            if (name) {
                definition.@def::name = name;
                if (def.uri in namespaces == false) {
                    namespaces[def.uri] = def;
                }
            }
        }
        // check to see if this value is a primitive
        var isPrimitive:Boolean = false;
        switch (typeof target) {
            case "boolean":
            case "number":
            case "string":
                isPrimitive = true;
                break;
        }
        // as a primitive, type properties are ignored and
        // a single child text node represents a value
        if (isPrimitive) {
            definition.appendChild(String(target));
            // not a primitive, add related attributes
            // and child elements
        }
        else {
            // go through type definition and define the
            // targets definition XML based on the
            // definition of the class
            var node:XML;
            var childNode:XML;
            var currValue:*;
            var propertyName:String;
            var propertyType:String;
            var filterType:String;
            var typeChildren:XMLList = typeDefinition.children();
            typeChildren: for each (node in typeChildren) {
                switchPropertyType: switch (node.localName()) {
                    case "accessor":
                    case "variable":
                        propertyName = node.@name;
                        currValue = target[propertyName];
                        propertyType = typeof target[propertyName];
                        // null values and functions are not included
                        if (currValue === undefined || currValue === null || propertyType == "function") {
                            break switchPropertyType;
                        }
                        // check if property is filtered
                        if (currentFilter) {
                            if (propertyName in currentFilter.properties) {
                                // get current filter type
                                filterType = currentFilter.properties[propertyName];
                            }
                            else {
                                // if not available, use default
                                filterType = currentFilter.defaultType;
                            }
                        }
                        else {
                            // no filter, default to include
                            filterType = XMLDefinitionFilter.INCLUDE;
                        }
                        switchFilter: switch (filterType) {
                            case XMLDefinitionFilter.INCLUDE:
                                // cannot create if readonly
                                if (node.@access != "readonly") {
                                    // make child objects for object-based values
                                    if (propertyType == "object") {
                                        // make child object
                                        create(target[propertyName], definition, null, propertyName);
                                    }
                                    else {
                                        // make attribute
                                        definition.@[propertyName] = target[propertyName];
                                    }
                                }
                                break switchFilter;
                            case XMLDefinitionFilter.EXCLUDE:
                                // exit, doing nothing
                                break switchFilter;
                            case XMLDefinitionFilter.PROPERTY:
                                // make as child object property using
                                // definition namespace (can include readonly)
                                create(target[propertyName], definition, null, propertyName, true);
                                break switchFilter;
                        }
                        break switchPropertyType;
                }
            }
            // for display objects, walk through the display
            // list and add children to the definition XML
            var targetContainer:DisplayObjectContainer = target as DisplayObjectContainer;
            if (targetContainer) {
                var childObject:DisplayObject;
                n = targetContainer.numChildren;
                for (i = 0; i < n; i++) {
                    childObject = targetContainer.getChildAt(0);
                    // name is not required as it is inherent
                    // to the DisplayObject definition
                    create(childObject, definition);
                }
            }
            // if a dynamic object, find and add dynamic properties
            if (typeDefinition.@isDynamic == "true") {
                dynamicLoop: for (p in target) {
                    propertyName = p;
                    currValue = target[propertyName];
                    propertyType = typeof target[propertyName];
                    // null values and functions are not included
                    if (currValue === undefined || currValue === null || propertyType == "function") {
                        continue dynamicLoop;
                    }
                    // check if property is filtered
                    if (currentFilter) {
                        if (propertyName in currentFilter.properties) {
                            // get current filter type
                            filterType = currentFilter.properties[propertyName];
                        }
                        else {
                            // if not available, use default
                            filterType = currentFilter.defaultType;
                        }
                    }
                    else {
                        // no filter, default to include
                        filterType = XMLDefinitionFilter.INCLUDE;
                    }
                    switchDFilter: switch (filterType) {
                        case XMLDefinitionFilter.INCLUDE:
                            // since there is no class type to check against only
                            // string types can be attribues in dynamic objects
                            if (propertyType == "string") {
                                // make attribute
                                definition.@[propertyName] = target[propertyName];
                            }
                            else {
                                // make child object
                                create(target[propertyName], definition, null, propertyName);
                            }
                            break switchDFilter;
                        case XMLDefinitionFilter.EXCLUDE:
                            // exit, doing nothing
                            break switchDFilter;
                        case XMLDefinitionFilter.PROPERTY:
                            // make as child object property using
                            // definition namespace (can include readonly)
                            create(target[propertyName], definition, null, propertyName, true);
                            break switchDFilter;
                    }
                }
            } // END dynamic
        } // END isPrimitive
        // update the parent XML if provided
        // with the current definition's XML
        if (xmlParent) {
            xmlParent.appendChild(definition);
        }
        if (firstCall) {
            // add accumulated namespaces to root node
            for (p in namespaces) {
                definition.addNamespace(namespaces[p]);
            }
            // first external call, clear static types
            types = null;
            namespaces = null;
            filterHash = null;
        }
        // return the current definition XML
        return definition;
    }

    /**
     * Creates an object (typically a display object) based on the definition
     * outlined by the XML.  Each XML element represents the object to be
     * made.  If that object's definition is in a pacakge, that element
     * will need to be in a namespace whose uri matches that package. The
     * hierarchy of the object created will match the hierarchy of the XML
     * where display objects will be added as children to the display objects.
     * Attributes are used to define properties.  If a name attribute is
     * defined, that name will also be used as a property name in the parent
     * to store a reference to the child.  If the parent is not a display
     * object container or the child is not a display object and a name
     * attribute is not provided, the child element's index will be used;
     * this is useful when defining arrays as name attributes are not needed.
     * <br /><br />
     * Errors (most if not all) will fail silently.
     * @param xml The xml to be parsed into an object.
     * @param targetParent The object in which the generated
     *         object will be defined, either as a property or a
     *         child display object.
     * @return A reference to the object created.
     */
    public static function parse(xml:XML, targetParent:Object = null):Object {
        // the name of the xml node (usually class name)
        var nodeName:String = String(xml.name());
        // the class reference
        var nodeClass:Class;
        // this node's instance
        var nodeObject:*;
        // define a name value based on name attribute if
        // it exists. This will be used to get or set
        // this definition within its parent
        var name:String = String(xml.@def::name);
        var instantiate:Boolean = false;
        var canHaveAttributes:Boolean = false;
        var isProperty:Boolean = false;
        // arguments lists
        var args:XMLList;
        // find special node name cases
        nodeType: switch (nodeName) {
            case "null":
            case "void":
                // ignore instantiation
                break nodeType;
            case def.uri + "::property":
                // if a property, the node object
                // is the value of this property
                // if name is defined, create object
                if (name)
                    nodeObject = targetParent[name];
                isProperty = true;
                break nodeType;
            case def.uri + "::call":
                // if a method, call the method with the arguments
                try {
                    args = xml.def::arguments.children();
                    switchArguments: switch (args.length()) {
                        case 0:
                            return targetParent[name]();
                            break switchArguments;
                        case 1:
                            return targetParent[name](parse(args[0], targetParent));
                            break switchArguments;
                        case 2:
                            return targetParent[name](parse(args[0], targetParent), parse(args[1], targetParent));
                        case 3:
                            return targetParent[name](parse(args[0], targetParent), parse(args[1], targetParent), parse(args[2], targetParent));
                            break switchArguments;
                        case 4:
                            return targetParent[name](parse(args[0], targetParent), parse(args[1], targetParent), parse(args[2], targetParent), parse(args[3], targetParent));
                            break switchArguments;
                        case 5:
                            return targetParent[name](parse(args[0], targetParent), parse(args[1], targetParent), parse(args[2], targetParent), parse(args[3], targetParent), parse(args[4], targetParent));
                            break switchArguments;
                        case 6:
                            return targetParent[name](parse(args[0], targetParent), parse(args[1], targetParent), parse(args[2], targetParent), parse(args[3], targetParent), parse(args[4], targetParent), parse(args[5], targetParent));
                        case 7:
                            return targetParent[name](parse(args[0], targetParent), parse(args[1], targetParent), parse(args[2], targetParent), parse(args[3], targetParent), parse(args[4], targetParent), parse(args[5], targetParent), parse(args[6], targetParent));
                        case 8:
                            return targetParent[name](parse(args[0], targetParent), parse(args[1], targetParent), parse(args[2], targetParent), parse(args[3], targetParent), parse(args[4], targetParent), parse(args[5], targetParent), parse(args[6], targetParent), parse(args[7], targetParent));
                        case 9:
                            return targetParent[name](parse(args[0], targetParent), parse(args[1], targetParent), parse(args[2], targetParent), parse(args[3], targetParent), parse(args[4], targetParent), parse(args[5], targetParent), parse(args[6], targetParent), parse(args[7], targetParent), parse(args[8], targetParent));
                            break switchArguments;
                        case 10:
                            return targetParent[name](parse(args[0], targetParent), parse(args[1], targetParent), parse(args[2], targetParent), parse(args[3], targetParent), parse(args[4], targetParent), parse(args[5], targetParent), parse(args[6], targetParent), parse(args[7], targetParent), parse(args[8], targetParent), parse(args[9], targetParent));
                            break switchArguments;
                        default:
                            return targetParent[name]();
                            break switchArguments;
                    }
                }
                catch (error:Error) {
                    // could not call method
                }
                return null;
                break nodeType;
            default:
                // this is a normal object to be instantiated
                instantiate = true;
                try {
                    nodeClass = Class(getDefinitionByName(nodeName));
                }
                catch (error:Error) {
                    // node name is not a recognized definition
                }
                // exit returning null if class could not be found
                if (!nodeClass)
                    return null;
                break nodeType;
        }
        // iteration variables
        var n:int;
        var i:int;
        // lists
        var children:XMLList = xml.children();
        var attributes:XMLList = xml.attributes();
        // if allowed to instantiate
        if (instantiate) {
            // check for primitive or null/void objcet type
            // and create nodeObject instance
            try {
                primitive: switch (nodeClass) {
                    case null:
                        nodeObject = null;
                        break primitive;
                    case Boolean:
                    case Number:
                    case int:
                    case uint:
                    case String:
                        // return primitive based on child node value
                        nodeObject = (children.length()) ? nodeClass(children[0]) : new nodeClass();
                        break primitive;
                    default:
                        // apply arguments; 10 maximum
                        args = xml.def::arguments.children();
                        switchArguments: switch (args.length()) {
                            case 0:
                                nodeObject = new nodeClass();
                                break switchArguments;
                            case 1:
                                nodeObject = new nodeClass(parse(args[0], targetParent));
                                break switchArguments;
                            case 2:
                                nodeObject = new nodeClass(parse(args[0], targetParent), parse(args[1], targetParent));
                            case 3:
                                nodeObject = new nodeClass(parse(args[0], targetParent), parse(args[1], targetParent), parse(args[2], targetParent));
                                break switchArguments;
                            case 4:
                                nodeObject = new nodeClass(parse(args[0], targetParent), parse(args[1], targetParent), parse(args[2], targetParent), parse(args[3], targetParent));
                                break switchArguments;
                            case 5:
                                nodeObject = new nodeClass(parse(args[0], targetParent), parse(args[1], targetParent), parse(args[2], targetParent), parse(args[3], targetParent), parse(args[4], targetParent));
                                break switchArguments;
                            case 6:
                                nodeObject = new nodeClass(parse(args[0], targetParent), parse(args[1], targetParent), parse(args[2], targetParent), parse(args[3], targetParent), parse(args[4], targetParent), parse(args[5], targetParent));
                            case 7:
                                nodeObject = new nodeClass(parse(args[0], targetParent), parse(args[1], targetParent), parse(args[2], targetParent), parse(args[3], targetParent), parse(args[4], targetParent), parse(args[5], targetParent), parse(args[6], targetParent));
                            case 8:
                                nodeObject = new nodeClass(parse(args[0], targetParent), parse(args[1], targetParent), parse(args[2], targetParent), parse(args[3], targetParent), parse(args[4], targetParent), parse(args[5], targetParent), parse(args[6], targetParent), parse(args[7], targetParent));
                            case 9:
                                nodeObject = new nodeClass(parse(args[0], targetParent), parse(args[1], targetParent), parse(args[2], targetParent), parse(args[3], targetParent), parse(args[4], targetParent), parse(args[5], targetParent), parse(args[6], targetParent), parse(args[7], targetParent), parse(args[8], targetParent));
                                break switchArguments;
                            case 10:
                                nodeObject = new nodeClass(parse(args[0], targetParent), parse(args[1], targetParent), parse(args[2], targetParent), parse(args[3], targetParent), parse(args[4], targetParent), parse(args[5], targetParent), parse(args[6], targetParent), parse(args[7], targetParent), parse(args[8], targetParent), parse(args[9], targetParent));
                                break switchArguments;
                            default:
                                nodeObject = new nodeClass();
                                break switchArguments;
                        }
                        canHaveAttributes = true;
                        break primitive;
                }
            }
            catch (error:Error) {
                // node object could not be created
            }
        } // END instantiate condition
        // apply attribues to object but only
        // if the object is not a primitive
        if (canHaveAttributes) {
            var attributeName:String;
            var attributeValue:*;
            // iterate through all attributes parsing
            // each one as a property of the new node object
            n = attributes.length();
            attributeLoop: for (i = 0; i < n; i++) {
                // skip any attribute in a namespace
                if (String(XML(attributes[i]).namespace())) {
                    continue attributeLoop;
                }
                // references
                attributeName = String(XML(attributes[i]).localName());
                attributeValue = XML(attributes[i]).valueOf();
                // assign attribute values
                try {
                    // do simple type conversions for
                    // some basic types
                    type: switch (typeof nodeObject[attributeName]) {
                        case "boolean":
                            // check for different possible values
                            // that could mean false
                            boolean: switch (attributeValue.toLowerCase()) {
                                case "false":
                                case "no":
                                case "0":
                                    nodeObject[attributeName] = false;
                                    break boolean;
                                default:
                                    nodeObject[attributeName] = true;
                                    break boolean;
                            }
                            break type;
                        case "number":
                            nodeObject[attributeName] = Number(attributeValue);
                            break type;
                        case "string":
                        default:
                            nodeObject[attributeName] = attributeValue;
                            break type;
                    }
                }
                catch (error:Error) {
                    // attribute value could not be
                    // assigned to new instance
                }
            }
        } // END attributes
        // set up children
        var childValueOf:String;
        n = children.length();
        // iterate through all children parsing
        // each one as a new node object
        childLoop: for (i = 0; i < n; i++) {
            // depending on the kind of node, define
            // a child or set up a primitive value
            nodeKind: switch (children[i].nodeKind()) {
                case "element":
                    // do not parse as child if an arguments node
                    if (String(children[i].name()) == def.uri + "::arguments") {
                        continue childLoop;
                    }
                    // create this child as an object
                    parse(children[i], nodeObject);
                    break nodeKind;
                case "text":
                    // use the text as a primitive valueOf
                    // value for the parent instance
                    try {
                        childValueOf = String(children[i]);
                        Object(nodeObject).valueOf = function ():String {
                            return childValueOf;
                        }
                    }
                    catch (error:Error) {
                        // valueOf could not be defined
                    }
                    break nodeKind;
                default:
                    // ignored node kind
                    break nodeKind;
            }
        } // END children
        // add node object as child of parent
        if (targetParent) {
            try {
                DisplayObjectContainer(targetParent).addChild(DisplayObject(nodeObject));
            }
            catch (error:Error) {
                // nodeObject is not a container or child
                // is not a display object
            }
            try {
                // define the value in the parent if name is available
                if (name) {
                    Object(targetParent)[name] = nodeObject;
                    // if no name, and parent is array, use index
                }
                else if (targetParent is Array) {
                    Object(targetParent)[xml.childIndex()] = nodeObject;
                }
            }
            catch (error:Error) {
                // child could not be added as a property
                // to the nodeObject
            }
        }
        // return the generated object
        return nodeObject;
    }
}
}

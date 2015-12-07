package hu.vpmedia.starlingx {
import com.adobe.utils.AGALMiniAssembler;

import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.Context3DVertexBufferFormat;
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;
import flash.geom.Matrix;
import flash.geom.Matrix3D;
import flash.geom.Rectangle;

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.errors.MissingContextError;
import starling.events.Event;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;
import starling.utils.MatrixUtil;
import starling.utils.VertexData;

/**
 * Display object with tile texture, may contain 16 TileTexture objects
 * @author KrechaGames - Łukasz 'Cywil' Cywiński
 * Thanks to Pierre Chamberlain - http://pierrechamberlain.ca/blog
 */
public class ScrollImage extends DisplayObject {
    private var mSyncRequired:Boolean;

    // vertex data
    private var mVertexData:VertexData;
    private var mVertexBuffer:VertexBuffer3D;

    // ShaderConstand and clipping index data
    private var mExtraBuffer:VertexBuffer3D;
    private var mExtraData:Vector.<Number>;

    // index data
    private var mIndexData:Vector.<uint>;
    private var mIndexBuffer:IndexBuffer3D;
    private var mTexture:Texture;

    // helper objects (to avoid temporary objects)
    private var sRenderColorAlpha:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0];
    private var sMatrix:Matrix3D = new Matrix3D();
    private var sPremultipliedAlpha:Boolean;
    private var sRegister:uint;

    //properties
    private var mCanvasWidth:Number;
    private var mCanvasHeight:Number;
    private var mTextureWidth:Number = 0;
    private var mTextureHeight:Number = 0;
    private var maxU:Number;
    private var maxV:Number;
    private var tempWidth:Number;
    private var tempHeight:Number;
    private var mMaxLayersAmount:uint;
    private static const BASE_PROGRAM:String = "SCROLL_IMAGE_AGAL";
    private var mBaseProgram:String = BASE_PROGRAM;

    //layers
    private var mLayers:Vector.<ScrollTile> = new Vector.<ScrollTile>();
    private var mLayersMatrix:Vector.<Matrix> = new Vector.<Matrix>();
    private var mMainLayer:ScrollTile;
    private var mLayerVertexData:VertexData;
    private var mFreez:Boolean;

    //paralax
    private var mPar:Boolean = true;
    private var mParOffset:Boolean = true;
    private var mParScale:Boolean = true;

    //transform
    private var mTilesOffsetX:Number = 0;
    private var mTilesOffsetY:Number = 0;
    private var mTilesRotation:Number = 0;
    private var mTilesScaleX:Number = 1;
    private var mTilesScaleY:Number = 1;
    private var mTilesPivotX:Number = 0;
    private var mTilesPivotY:Number = 0;
    private var mTextureRatio:Number;
    private var mUseBaseTexture:Boolean;

    /**
     * Creates an object with tiled texture. Default without mipMapping to avoid some borders anrtefacts. Property use BaseTexture determinant using whole texture (without UV clipping) - use it for better performance special on mobile.
     * @param width
     * @param height
     * @param useBaseTexture
     */
    public function ScrollImage(width:Number, height:Number, useBaseTexture:Boolean = false) {
        this.mUseBaseTexture = useBaseTexture;
        //0,1,2,3 - transform matrix, 4 - alpha, must start from vc5
        sRegister = 5;

        //maximum amount of layers
        mMaxLayersAmount = 16;

        //base program without tint/alpha/mipmaps and with blinear smoothing
        this.mCanvasWidth = width;
        this.mCanvasHeight = height;

        resetVertices();
        registerPrograms();

        mSyncRequired = false;

        // handle lost context
        Starling.current.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
    }

    /**
     * Context created handler
     * @param event
     */
    private function onContextCreated(event:Event):void {
        //the old context was lost, so we create new buffers and shaders.
        createBuffers();
        registerPrograms();
    }

    /**
     * Reset vertexData
     */
    private function resetVertices():void {
        mVertexData = new VertexData(0);
        mIndexData = new Vector.<uint>();
        mExtraData = new Vector.<Number>();
    }

    /**
     * Add layer on the top.
     * @param layer
     * @return
     */
    public function addLayer(layer:ScrollTile):ScrollTile {
        return addLayerAt(layer, numLayers + 1);
    }

    /**
     * Add layer at index.
     * @param layer
     * @param index
     * @return
     */
    public function addLayerAt(layer:ScrollTile, index:int):ScrollTile {
        if (index > numLayers) index = numLayers + 1;

        if (mLayers.length == 0 && mLayers.length < mMaxLayersAmount) {
            mainSetup(layer);
        } else if (mTexture != layer.baseTexture) {
            throw new Error("Layers must use this same texture.");

        } else if (mLayers.length >= mMaxLayersAmount) {
            throw new Error("Maximum layers amount has been reached! Max is " + mMaxLayersAmount);
        }

        mLayers.splice(index, 0, layer);
        mLayersMatrix.splice(index, 0, new Matrix());

        updateMesh();
        return layer;
    }

    /**
     * Remove layer at index.
     * @param id
     */
    public function removeLayerAt(id:int):void {
        if (mLayers.length && id < mLayers.length) {
            mLayers.splice(id, 1);
            mLayersMatrix.splice(id, 1);

            if (mLayers.length) {
                updateMesh();
            } else {
                reset();
            }
        } else {
            return;
        }
    }

    /**
     * Remove all layers.
     * @param dispose
     */
    public function removeAll(dispose:Boolean = false):void {
        if (dispose) {
            for (var i:int = 0; i < mLayers.length; i++) {
                mLayers[i].dispose();
            }
        }
        reset();
    }

    /**
     * Return layer at index.
     * @param layer
     */
    public function getLayerAt(index:uint):ScrollTile {
        if (index < mLayers.length)
            return mLayers[index];
        return null;
    }

    /**
     * Setup object property using first layer.
     * @param layer
     */
    private function mainSetup(layer:ScrollTile, updateCanvas:Boolean = false):void {
        mMainLayer = layer;
        mTexture = mMainLayer.baseTexture;
        sPremultipliedAlpha = mTexture.premultipliedAlpha;

        mTextureWidth = mTexture.width;
        mTextureHeight = mTexture.height;

        mTextureRatio = mTextureWidth / mTextureHeight;

        maxU = mCanvasWidth / mTextureWidth;
        maxV = mCanvasHeight / mTextureHeight;

        mLayerVertexData = new VertexData(4);

        mLayerVertexData.setPosition(0, 0, 0);
        mLayerVertexData.setPosition(1, mCanvasWidth, 0);
        mLayerVertexData.setPosition(2, 0, mCanvasHeight);
        mLayerVertexData.setPosition(3, mCanvasWidth, mCanvasHeight);

        mLayerVertexData.setTexCoords(0, 0, 0);
        mLayerVertexData.setTexCoords(1, maxU, 0);
        mLayerVertexData.setTexCoords(2, 0, maxV);
        mLayerVertexData.setTexCoords(3, maxU, maxV);


        if (updateCanvas)    updateMesh();
    }

    /**
     * Update mesh
     */
    private function updateMesh():void {
        if (mMainLayer) {
            resetVertices();

            for (var i:int = 0; i < mLayers.length; i++) {
                setupVertices(i, mLayers[i]);
            }
            if (mLayers.length) createBuffers();
        }
    }

    /**
     * Reset all resources.
     */
    private function reset():void {
        mLayers = new Vector.<ScrollTile>();
        mLayersMatrix = new Vector.<Matrix>();
        mMainLayer = null;
        mTextureWidth = mTextureHeight = 0;
        resetVertices();
    }

    /**
     * Returns a rectangle that completely encloses the object as it appears in another coordinate system.
     * @param targetSpace
     * @param resultRect
     * @return
     */
    public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle = null):Rectangle {
        if (resultRect == null)
            resultRect = new Rectangle();
        var transformationMatrix:Matrix = getTransformationMatrix(targetSpace);
        return mVertexData.getBounds(transformationMatrix, 0, -1, resultRect);
    }

    /**
     * Creates vertex for a layer.
     * @param id
     * @param layer
     */
    private function setupVertices(id:int, layer:ScrollTile):void {
        mVertexData.append(mLayerVertexData);

        mIndexData[int(id * 6)] = id * 4;
        mIndexData[int(id * 6 + 1)] = id * 4 + 1;
        mIndexData[int(id * 6 + 2)] = id * 4 + 2;
        mIndexData[int(id * 6 + 3)] = id * 4 + 1;
        mIndexData[int(id * 6 + 4)] = id * 4 + 3;
        mIndexData[int(id * 6 + 5)] = id * 4 + 2;

        var i:int = -1;
        while (++i < 4) {
            mExtraData.push(getColorRegister(id), getTransRegister(id), int(sPremultipliedAlpha), layer.baseClipping.x, layer.baseClipping.y, layer.baseClipping.width, layer.baseClipping.height);
        }
    }

    /**
     * Return next free color register number.
     * @param id
     * @return
     */
    private function getColorRegister(id:uint):uint {
        return sRegister + ( id * 5 );
    }

    /**
     * Return next free transform register number.
     * @param id
     * @return
     */
    private function getTransRegister(id:uint):uint {
        return sRegister + ( id * 5 ) + 1;
    }

    /**
     * Creates new vertex- and index-buffers and uploads our vertex- and index-data to those buffers.
     */
    private function createBuffers():void {
        //check if width/height was set before vertex creation
        if (tempWidth) width = tempWidth;
        if (tempHeight) height = tempHeight;

        var context:Context3D = Starling.context;
        if (context == null)
            throw new MissingContextError();

        if (context.driverInfo == "Disposed") return;

        if (mVertexBuffer)
            mVertexBuffer.dispose();
        if (mIndexBuffer)
            mIndexBuffer.dispose();
        if (mExtraBuffer)
            mExtraBuffer.dispose();

        mVertexBuffer = context.createVertexBuffer(mVertexData.numVertices, VertexData.ELEMENTS_PER_VERTEX);
        mVertexBuffer.uploadFromVector(mVertexData.rawData, 0, mVertexData.numVertices);

        mExtraBuffer = context.createVertexBuffer(mVertexData.numVertices, 7);
        mExtraBuffer.uploadFromVector(mExtraData, 0, mVertexData.numVertices);

        mIndexBuffer = context.createIndexBuffer(mIndexData.length);
        mIndexBuffer.uploadFromVector(mIndexData, 0, mIndexData.length);
    }

    /**
     * Renders the object with the help of a 'support' object and with the accumulated alpha of its parent object.
     * @param support
     * @param alpha
     */
    public override function render(support:RenderSupport, alpha:Number):void {
        if (mLayers.length == 0) return;
        support.raiseDrawCount();

        support.finishQuadBatch();
        if (mSyncRequired) syncBuffers();

        var context:Context3D = Starling.context;
        if (context == null)
            throw new MissingContextError();

        // apply the current blendmode
        support.applyBlendMode(sPremultipliedAlpha);

        //set texture
        if (mTexture)
            context.setTextureAt(0, mTexture.base);

        //set buffers
        context.setVertexBufferAt(0, mVertexBuffer, VertexData.POSITION_OFFSET, Context3DVertexBufferFormat.FLOAT_2); //position
        context.setVertexBufferAt(1, mVertexBuffer, VertexData.TEXCOORD_OFFSET, Context3DVertexBufferFormat.FLOAT_2); //UV
        context.setVertexBufferAt(2, mExtraBuffer, VertexData.POSITION_OFFSET, Context3DVertexBufferFormat.FLOAT_3); //vc for color and transform registers
        context.setVertexBufferAt(3, mExtraBuffer, 3, Context3DVertexBufferFormat.FLOAT_4); //clipping

        //set alpha
        sRenderColorAlpha[3] = this.alpha * alpha;

        //set object and layers data
        context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, support.mvpMatrix3D, true);
        context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, sRenderColorAlpha, 1);

        var layer:ScrollTile;
        for (var i:int = 0; i < mLayers.length; i++) {
            layer = mLayers[i];

            MatrixUtil.convertTo3D(mFreez ? mLayersMatrix[i] : calculateMatrix(layer, mLayersMatrix[i]), sMatrix);
            context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, getColorRegister(i), layer.colorTrans, 1);
            context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, getTransRegister(i), sMatrix, true);
        }

        // activate program (shader)
        context.setProgram(Starling.current.getProgram(mBaseProgram));

        //draw the object
        context.drawTriangles(mIndexBuffer, 0, mIndexData.length / 3);

        //reset buffers
        if (mTexture) {
            context.setTextureAt(0, null);
        }

        context.setVertexBufferAt(0, null);
        context.setVertexBufferAt(1, null);
        context.setVertexBufferAt(2, null);
        context.setVertexBufferAt(3, null);
    }

    /**
     * Uploads the raw data of all batched quads to the vertex buffer.
     */
    private function syncBuffers():void {
        if (mVertexBuffer == null)
            createBuffers();
        else {
            mVertexBuffer.uploadFromVector(mVertexData.rawData, 0, mVertexData.numVertices);
            mSyncRequired = false;
        }
    }

    /**
     * Calculate matrix transform for a layer
     * @param layer
     * @param matrix
     * @return
     */
    private function calculateMatrix(layer:ScrollTile, matrix:Matrix):Matrix {
        var pOffset:Number = mParOffset ? layer.paralax : 1;
        var pScale:Number = mParScale ? layer.paralax : 1;
        var angle:Number = layer.rotation + tilesRotation;

        matrix.identity();
        MatrixUtil.prependTranslation(matrix, -mTilesPivotX % 1, -mTilesPivotY % 1);

        //for no square ratio, scale to square

        if (mTextureRatio != 1) matrix.scale(1, 1 / mTextureRatio);
        matrix.scale(1 / (layer.scaleX * 1 / pScale) / tilesScaleX + 1 - pScale, 1 / (layer.scaleY * 1 / pScale) / tilesScaleY + 1 - pScale);
        matrix.rotate(-angle);
        //for no square ratio, unscale from square to orginal ratio
        if (mTextureRatio != 1) matrix.scale(1, mTextureRatio);

        matrix.translate((mTilesPivotX - (layer.offsetX + mTilesOffsetX ) / mTextureWidth * pOffset) % layer.baseClipping.width, (mTilesPivotY - (layer.offsetY + mTilesOffsetY ) / mTextureHeight * pOffset) % layer.baseClipping.height);

        return matrix;
    }


    /**
     * Register the programs
     */
    private function registerPrograms():void {
        var target:Starling = Starling.current;
        if (target.hasProgram(mBaseProgram))
            return; // already registered
        preparePrograms()
    }

    /**
     * Upload all programs.
     */
    public static function preparePrograms():void {
        // SETTINGS
        const format:String = Context3DTextureFormat.BGRA;
        const smoothing:String = TextureSmoothing.BILINEAR;
        const mipmap:Boolean = false;
        const useBase:Boolean = false;
        const tinted:Boolean = false;
        // LOGIC
        var target:Starling = Starling.current;
        // create vertex and fragment programs from assembly
        var vertexProgramAssembler:AGALMiniAssembler = new AGALMiniAssembler();
        var fragmentProgramAssembler:AGALMiniAssembler = new AGALMiniAssembler();

        var vertexProgramCode:String;
        var fragmentProgramCode:String;
        // va0 -> position
        // va1 -> UV
        // va2.x -> vc index for color
        // va2.y -> vc index for transformation
        // va2.z -> premultiplied alpha 1/0
        // va3 -> clipping
        // vc0 -> mvpMatrix (4 vectors, vc0 - vc3)
        // vc4 -> alpha and color

        //vc[va2.x] -> color and alpha for layer
        //vc[va2.y] -> matrix transform for layer

        //pass to fragment shader
        //v0 -> color
        //v1 -> uv
        //v2 -> x,y of start
        //v3 ->width, height and reciprocals

        const clippingData:String =
                "mov v2, vt2 \n" +     						// pass the x and y of start
                "mov v3.xy, vt2.zw \n" +   					// pass the width & height
                "rcp v3.z, vt2.z \n" +   					// pass the reciprocals of width
                "rcp v3.w, vt2.w \n"; 						// pass the reciprocals of heigh

        const clippingUV:String =
                "mul ft0.xy, ft0.xy, v3.zw \n" + 			// multiply to larger number
                "frc ft0.xy, ft0.xy \n" +					// keep the fraction of the large number
                "mul ft0.xy, ft0.xy, v3.xy \n" + 			// multiply to smaller number
                "add ft0.xy, ft0.xy, v2.xy \n";				// add the start x & y of the tile


        vertexProgramCode = tinted ?
        "mov vt0, vc4 \n" + 						// store color in temp0
        "mul vt0, vt0, vc[va2.x] \n" + 				// multiply color with alpha for layer and pass it to fragment shader
        "pow vt1, vt0.w, va2.z \n" + 				// if mPremulitply == 0 alpha multiplayer == 1
        "mul vt0.xyz, vt0.xyz, vt1.xxx \n" + 		// multiply color by alpha
        "mov v0, vt0 \n" 							// pass it to fragment shader
                :
                "mov v0, vc4 \n";  							// pass color to fragment shader

        vertexProgramCode +=
                "mov vt2, va3 \n"; 	 						// store in temp1 the tile clipping

        vertexProgramCode += useBase ? '' : clippingData;
        vertexProgramCode +=
                "m44 vt2, va1, vc[va2.y] \n" + 				// mutliply UV by transform matrix
                "mov v1, vt2 \n" +  						// pass the uvs.

                "m44 op, va0, vc0 \n"; 						// 4x4 matrix transform to output space

        vertexProgramAssembler.assemble(Context3DProgramType.VERTEX, vertexProgramCode);
        fragmentProgramCode =
                "mov ft0, v1 \n"; 							// sotre UV`a to temp0

        fragmentProgramCode += useBase ? '' : clippingUV;

        fragmentProgramCode +=
                "tex ft1, ft0, fs0 <???> \n"; 				// sample texture 0

        fragmentProgramCode += tinted ?
                "mul oc, ft1, v0 \n"   						// multiply color with texel color and output
                :
                "mov oc, ft1 \n";   							// output

        var options:Array = ["2d"];

        if (format == Context3DTextureFormat.COMPRESSED)
            options.push("dxt1");
        else if (format == "compressedAlpha")
            options.push("dxt5");

        if (smoothing == TextureSmoothing.NONE)
            options.push("nearest", mipmap ? "mipnearest" : "mipnone");
        else if (smoothing == TextureSmoothing.BILINEAR)
            options.push("linear", mipmap ? "mipnearest" : "mipnone");
        else
            options.push("linear", mipmap ? "miplinear" : "mipnone");

        if ((target.profile != "baselineConstrained") && !useBase)
            options.push("clamp");
        else
            options.push("repeat");

        fragmentProgramAssembler.assemble(Context3DProgramType.FRAGMENT,
                fragmentProgramCode.replace("???", options.join()));

        target.registerProgram(BASE_PROGRAM, vertexProgramAssembler.agalcode, fragmentProgramAssembler.agalcode);


    }

    /**
     * Disposes all resources of the display object.
     */
    public override function dispose():void {
        Starling.current.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated);

        if (mVertexBuffer)
            mVertexBuffer.dispose();
        if (mIndexBuffer)
            mIndexBuffer.dispose();

        mLayers = null;
        mLayersMatrix = null;
        mTexture = null;

        super.dispose();
    }

    /**
     * Canvas width & hight in pixels - better perfomance with one upload
     */
    public function setCanvasSize(width:Number, height:Number):void {
        mCanvasWidth = width;
        mCanvasHeight = height;
        if (mMainLayer) {
            mainSetup(mMainLayer, true);
            mSyncRequired = true;
        }
    }

    /**
     * Canvas width in pixels.
     */
    public function get canvasWidth():Number {
        return mCanvasWidth;
    }

    /**
     * Canvas width in pixels.
     */
    public function set canvasWidth(value:Number):void {
        mCanvasWidth = value;
        if (mMainLayer) {
            mainSetup(mMainLayer, true);
            mSyncRequired = true;
        }
    }

    /**
     * Canvas height in pixels.
     */
    public function get canvasHeight():Number {
        return mCanvasHeight;
    }

    /**
     * Canvas height in pixels.
     */
    public function set canvasHeight(value:Number):void {
        mCanvasHeight = value;

        if (mMainLayer) {
            mainSetup(mMainLayer, true);
            mSyncRequired = true;
        }
    }

    /**
     * @inheritDocs
     */
    override public function get width():Number {
        return numLayers == 0 ? super.width : 0;
    }

    /**
     * @inheritDocs
     */
    override public function set width(value:Number):void {
        if (mTextureWidth) {
            super.width = value;
            tempWidth = 0;
        } else {
            tempWidth = value;
        }
    }

    /**
     * @inheritDocs
     */
    override public function get height():Number {
        return numLayers == 0 ? super.height : 0;
    }

    /**
     * @inheritDocs
     */
    override public function set height(value:Number):void {
        if (mTextureHeight) {
            super.height = value;
            tempHeight = 0;
        } else {
            tempHeight = value;
        }
    }

    /**
     * Texture used in object - from the layer on index 0.
     */
    public function get texture():Texture {
        return mTexture;
    }

    /**
     * The horizontal scale factor. '1' means no scale, negative values flip the tiles.
     */
    public function get tilesScaleX():Number {
        return mTilesScaleX;
    }

    /**
     * The horizontal scale factor. '1' means no scale, negative values flip the tiles.
     */
    public function set tilesScaleX(value:Number):void {
        mTilesScaleX = value;
    }

    /**
     * The vertical scale factor. '1' means no scale, negative values flip the tiles.
     */
    public function get tilesScaleY():Number {
        return mTilesScaleY;
    }

    /**
     * The vertical scale factor. '1' means no scale, negative values flip the tiles.
     */
    public function set tilesScaleY(value:Number):void {
        mTilesScaleY = value;
    }

    /**
     * The x offet of the tiles.
     */
    public function get tilesOffsetX():Number {
        return mTilesOffsetX;
    }

    /**
     * The x offet of the tiles.
     */
    public function set tilesOffsetX(value:Number):void {
        mTilesOffsetX = value;
    }

    /**
     * The y offet of the tiles.
     */
    public function get tilesOffsetY():Number {
        return mTilesOffsetY;
    }

    /**
     * The y offet of the tiles.
     */
    public function set tilesOffsetY(value:Number):void {
        mTilesOffsetY = value;
    }

    /**
     * The rotation of the tiles in radians.
     */
    public function get tilesRotation():Number {
        return mTilesRotation;
    }

    /**
     * The rotation of the tiles in radians.
     */
    public function set tilesRotation(value:Number):void {
        mTilesRotation = value;
    }

    /**
     * The x pivot for rotation and scale the tiles.
     */
    public function get tilesPivotX():Number {
        return mTilesPivotX * mTextureWidth;
    }

    /**
     * The x pivot for rotation and scale the tiles.
     */
    public function set tilesPivotX(value:Number):void {
        mTilesPivotX = mTextureWidth ? value / mTextureWidth : 0;
    }

    /**
     * The y pivot for rotation and scale the tiles.
     */
    public function get tilesPivotY():Number {
        return mTilesPivotY * mTextureHeight;
    }

    /**
     * The y pivot for rotation and scale the tiles.
     */
    public function set tilesPivotY(value:Number):void {
        mTilesPivotY = mTextureHeight ? value / mTextureHeight : 0;
    }

    /**
     * Determinate parlax for offset.
     */
    public function get paralaxOffset():Boolean {
        return mParOffset;
    }

    /**
     * Determinate parlax for offset.
     */
    public function set paralaxOffset(value:Boolean):void {
        mParOffset = value;
    }

    /**
     * Determinate parlax for scale.
     */
    public function get paralaxScale():Boolean {
        return mParScale;
    }

    /**
     * Determinate parlax for scale.
     */
    public function set paralaxScale(value:Boolean):void {
        mParScale = value;
    }

    /**
     * Determinate parlax for all transformations.
     */
    public function get paralax():Boolean {
        return mPar;
    }

    /**
     * Determinate parlax for all transformations.
     */
    public function set paralax(value:Boolean):void {
        mPar = value;
        paralaxOffset = value;
        paralaxScale = value;
    }

    /**
     * Avoid all tiles transformations - for better performance matrixes are not calculate.
     */
    public function get freez():Boolean {
        return mFreez;
    }

    /**
     * Avoid all tiles transformations - for better performance matrixes are not calculate.
     */
    public function set freez(value:Boolean):void {
        for (var i:int = 0; i < mLayers.length; i++) {
            calculateMatrix(mLayers[i], mLayersMatrix[i]);
        }
        mFreez = value;
    }

    /**
     * Return number of layers
     */
    public function get numLayers():int {
        return mLayers.length;
    }


}
}

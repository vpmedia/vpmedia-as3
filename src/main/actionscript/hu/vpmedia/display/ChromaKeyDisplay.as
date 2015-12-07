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

// Flash 10 Color Difference Key Method
//
// Author: Mario Klingemann
//
// http://www.quasimondo.com
//
// CHANGES: 2011.02.18.
// Ported to AS3 by Andras Csizmadia <andras@vpmedia.eu>
//
//
// This technique is released under
// Creative Commons Attribution 2.5 Liciense
// http://creativecommons.org/licenses/by/2.5/
//
// This means that you may use it for any commercial
// or non-commercial purpos as long as you give proper
// credit in the form of a visible line:
// Video keying by Mario Klingemann
// which is hyperlinked to http://www.quasimondo.com
// If you cannot comply to this prerequisite please
// contact me under mario@quasimondo.com for permission.
package hu.vpmedia.display {
// import fl.video.FLVPlayback;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.IBitmapDrawable;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.BlurFilter;
import flash.filters.DisplacementMapFilter;
import flash.filters.GlowFilter;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import hu.vpmedia.math.ColorMatrix;

public class ChromaKeyDisplay extends Sprite {
    private var original:BitmapData;
    private var transformMap:BitmapData;
    private var helperMap:BitmapData;
    private var background:BitmapData;
    private var backgroundHelper:BitmapData;
    private var displaceMap:BitmapData;
    private var masker:BitmapData;
    private var display:BitmapData;
    private var defringe:BitmapData;
    private var defringeGlow:GlowFilter;
    private var preblurFilter:BlurFilter;
    private var postblurFilter:BlurFilter;
    private var displaceFilter:DisplacementMapFilter;
    private var perlinPoint:Array;
    private var defringer:MovieClip;
    private var rect:Rectangle;
    private var zero:Point;
    private var mat:Matrix;
    private var cm:ColorMatrix;
    //  public var ct:ColorTransform;
    private var usePrecise:Boolean;
    private var alphaArray:Array;
    private var nullArray:Array;
    private var keyColor:Number;
    private var keyOn:Boolean;
    private var defringeMode1:Boolean;
    private var defringeMode2:Boolean;
    private var displayMode1:Boolean;
    private var displayMode2:Boolean;
    private var defringeRadius:int;
    private var defringeAmount:int;
    private var preBlur:int;
    private var postBlur:int;
    private var maskIn:int;
    private var maskOut:int;
    private var maskGamma:int;
    private var source:IBitmapDrawable;
    private var sourceMatrix:Matrix;
    public static const DISPLAY_IMAGE:int = 1;
    public static const DISPLAY_MASK:int = 2;
    public static const DEFRINGE_NONE:int = 0;
    public static const DEFRINGE_LIGHTER:int = 1;
    public static const DEFRINGE_DARKER:int = 2;

    public function ChromaKeyDisplay(precise:Boolean = false) {
        // constructor code
        usePrecise = precise;
        init();
    }

    private function init():void {
        trace(this, "init");
        // model
        alphaArray = [];
        nullArray = [];
        for (var i:int = 0; i < 256; i++) {
            nullArray[i] = 0x00000000;
        }
        perlinPoint = [0, 0];
        // view
        original = new BitmapData(320, 240, false, 0);
        rect = original.rect;
        transformMap = original.clone();
        helperMap = original.clone();
        background = original.clone();
        backgroundHelper = original.clone();
        displaceMap = original.clone();
        masker = new BitmapData(original.width, original.height, true, 0);
        display = masker.clone();
        defringe = masker.clone();
        displaceFilter = new DisplacementMapFilter(displaceMap, zero, 1, 1, 0, -10, "wrap");
        zero = new Point();
        mat = new Matrix();
        sourceMatrix = new Matrix(1, 0, 0, 1, 0, 0);
        cm = new ColorMatrix();
        addChild(new Bitmap(background));
        addChild(new Bitmap(display));
        background.fillRect(background.rect, 0xffffff);
        defringer = new MovieClip();
        addChild(defringer);
        defringer.name = "defringer";
        defringer.addChild(new Bitmap(defringe));
        defringer.blendMode = BlendMode.SUBTRACT;
    }

    // API
    public function setSource(value:IBitmapDrawable):void {
        source = value;
        original.draw(source);
        //changeKeyColor(original.getPixel(310,16));
        calculateAlphaTables();
        draw();
    }

    public function setMaskIn(value:int):void {
        maskIn = value;
        calculateAlphaTables();
    }

    public function setMaskOut(value:int):void {
        maskOut = value;
        calculateAlphaTables();
    }

    public function setMaskGamma(value:int):void {
        maskGamma = value;
        calculateAlphaTables();
    }

    public function setDefringeAmount(value:int):void {
        defringeAmount = value;
        updateDefringeGlow();
    }

    public function setDefringeRadius(value:int):void {
        defringeRadius = value;
        updateDefringeGlow();
    }

    public function setPreBlur(value:int):void {
        preBlur = value;
        updatePreblurFilter();
    }

    public function setPostBlur(value:int):void {
        postBlur = value;
        updatePostblurFilter();
    }

    public function setKey(value:Boolean):void {
        keyOn = value;
    }

    public function setDefringeMode(value:int):void {
        if (value == DEFRINGE_LIGHTER) {
            defringeMode1 = true;
            defringeMode2 = false;
        }
        else if (value == DEFRINGE_DARKER) {
            defringeMode1 = false;
            defringeMode2 = true;
        }
        else if (value == DEFRINGE_NONE) {
            defringeMode1 = false;
            defringeMode2 = false;
        }
    }

    public function setDisplayMode(value:int):void {
        if (value == DISPLAY_IMAGE) {
            displayMode1 = true;
            displayMode2 = false;
        }
        else if (value == DISPLAY_MASK) {
            displayMode1 = false;
            displayMode2 = true;
        }
    }

    public function changeKeyColor(value:Number):void {
        //trace(this, "changeKeyColor",value);
        keyColor = value;
        transformMap.fillRect(rect, value);
        updateDefringeGlow();
    }

    public function sampleColor(vX:int, vY:int):int {
        return original.getPixel(vX, vY);
    }

    // PRIVATE
    private function updateDefringeGlow():void {
        //trace(this, "updateDefringeGlow");
        defringeGlow = new GlowFilter((defringeMode1 ? 0x000000 : 0xffffff) ^ keyColor, 1, defringeRadius / 100, defringeRadius / 100, defringeAmount / 100, 3, true, true);
        defringer.visible = (displayMode1 && keyOn && defringeAmount > 0 && defringeRadius > 0);
    }

    private function updatePreblurFilter():void {
        //trace(this, "updatePreblurFilter");
        preblurFilter = new BlurFilter(1 + preBlur / 10, 1 + preBlur / 10, 1);
    }

    private function updatePostblurFilter():void {
        //trace(this, "updatePostblurFilter");
        postblurFilter = new BlurFilter(1 + postBlur / 10, 1 + postBlur / 10, 1);
    }

    private function calculateAlphaTables():void {
        //trace(this, "calculateAlphaTables");
        // this function creates the lookup table for the paletteMap filter
        // which makes the mask out of the color difference screen
        var alpha_in:int = Math.round(maskIn);
        var alpha_out:int = Math.round(maskOut);
        for (var i:int = 0; i < alpha_in; i++) {
            alphaArray[i] = 0;
        }
        var f:Number = 1 / (alpha_out - alpha_in);
        var n:Number = f;
        for (i = alpha_in; i < alpha_out; i++) {
            alphaArray[i] = Math.round(255 * Math.pow(n, 1.0 / (maskGamma / 100))) << 24 | 0xffffff;
            n += f;
        }
        for (i = alpha_out; i < 256; i++) {
            alphaArray[i] = 0xffffffff;
        }
    }

    private function createKey():void {
        // trace(this, "createKey");
        // Prebluring will reduce compression artefacts and smooth the edges
        if (preBlur > 0) {
            masker.applyFilter(original, rect, zero, preblurFilter);
        }
        else {
            masker.draw(original);
        }
        // Subtracts the key color from the image
        masker.draw(transformMap, mat, null, "difference");
        if (usePrecise) {
            // This method finds the biggest color difference of all channels - I'm not sure if this is really more precise than the average method
            helperMap.copyChannel(masker, rect, zero, 1, 4);
            masker.draw(helperMap, mat, new ColorTransform(0, 0, 1, 1, 0, 0, 0, 0), "lighten");
            helperMap.copyChannel(masker, rect, zero, 2, 4);
            masker.draw(helperMap, mat, new ColorTransform(0, 0, 1, 1, 0, 0, 0, 0), "lighten");
        }
        else {
            // this calculates the average color difference
            cm.reset();
            cm.average();
            masker.applyFilter(masker, rect, zero, cm.filter);
        }
        // maps the accumulated difference from the blue channel to the alpha channel and creates the mask
        masker.paletteMap(masker, rect, zero, nullArray, nullArray, alphaArray, nullArray);
        // blurs the mask edges
        if (postBlur > 0) {
            masker.applyFilter(masker, rect, zero, postblurFilter);
        }
    }

    // drawer
    public function draw(event:Event = null):void {
        drawBackground();
        drawOriginal();
        if (keyOn) {
            drawKeyDisplay();
        }
        else {
            drawNormalDisplay();
        }
    }

    private function drawOriginal():void {
        try {
            original.lock();
            original.draw(source, sourceMatrix);
            original.unlock();
        }
        catch (e:Error) {
        }
    }

    private function drawKeyDisplay():void {
        try {
            createKey();
            display.lock();
            if (displayMode2) {
                // show mask
                display.fillRect(rect, 0xff000000);
                display.draw(masker);
            }
            else {
                // mask the video
                display.copyPixels(original, rect, zero, masker, zero, false);
            }
            display.unlock();
            //
            if (defringeAmount > 0 && defringeRadius > 0) {
                defringe.applyFilter(masker, rect, zero, defringeGlow);
            }
        }
        catch (e:Error) {
        }
    }

    private function drawNormalDisplay():void {
        try {
            display.lock();
            display.draw(original);
            display.unlock();
        }
        catch (e:Error) {
        }
    }

    private function drawBackground():void {
        backgroundHelper.scroll(0, -1);
        if (Math.random() < 0.1) {
            var rnd1:Number = Math.floor(Math.random() * 0x100);
            var rnd2:Number = Math.floor(Math.random() * rnd1);
            backgroundHelper.fillRect(new Rectangle(0, 239, 320, 1), rnd1 << 16 | rnd2 << 8);
        }
        displaceMap.perlinNoise(256, 16, 1, 6543, false, true, 1, false, perlinPoint);
        perlinPoint[0] += 0.5;
        background.applyFilter(backgroundHelper, rect, zero, displaceFilter);
    }
}
}

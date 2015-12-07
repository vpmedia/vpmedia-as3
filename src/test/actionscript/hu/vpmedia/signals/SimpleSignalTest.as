/*
 * =BEGIN CLOSED LICENSE
 *
 * Copyright (c) 2013 Andras Csizmadia
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
package hu.vpmedia.signals {

import flash.display.Sprite;

import flexunit.framework.Assert;

public class SimpleSignalTest extends Sprite {
    private var signal:SimpleSignal;

    private function listener():void {
    }

    private function listener2():void {
    }

    [Before]
    public function setUp():void {
        signal = new SimpleSignal();
    }

    [After]
    public function tearDown():void {
        signal.removeAll();
        signal = null;
    }

    [Test]
    public function test_instantiate():void {
        Assert.assertNotNull(signal);
    }

    [Test]
    public function test_callback_uint():void {
        // uint
        signal.add(function (a:uint):void {
            Assert.assertTrue(a, 1);
        });
        signal.dispatch(1);
    }

    [Test]
    public function test_callback_str():void {
        // string
        signal.add(function (a:String):void {
            Assert.assertEquals(a, "1");
        });
        signal.dispatch("1");
    }

    [Test]
    public function test_callback_obj():void {
        // object
        signal.add(function (a:Object):void {
            Assert.assertEquals(a.a, "1");
        });
        signal.dispatch({a: "1"});
    }

    [Test]
    public function test_callback_arr():void {
        // varargs
        signal.add(function (a:Array, b:String, c:Number):void {
            Assert.assertEquals(a.length, 1);
            Assert.assertEquals(a[0], 2);
            Assert.assertEquals(b, "test");
            Assert.assertEquals(c, 0.5);
        });
        signal.dispatch([2], "test", 0.5);
    }

    [Test]
    public function test_removeAll():void {
        signal.add(function ():void {
        });
        Assert.assertEquals(signal.numListeners(), 1);
        signal.removeAll();
        Assert.assertEquals(signal.numListeners(), 0);
    }

    /* [Test]
     public function test_inline_method_after_gc():void {
     signal.add(function ():void {
     });
     Assert.assertEquals(signal.numListeners(), 1);
     SystemUtil.gc(true);
     SystemUtil.gc(false);
     signal.dispatch();
     Assert.assertEquals(signal.numListeners(), 0);
     }    */

    [Test(description="should dispatch with instance of sprite.")]
    public function dispatch_with_argument():void {
        function checkSprite(spriteArg:Sprite):void {
            Assert.assertStrictlyEquals(sprite, spriteArg);
        }

        var sprite:Sprite = new Sprite();

        signal.add(checkSprite);
        signal.dispatch(sprite);
    }

    [Test(description="should have no listeners - length of 0")]
    public function no_listeners():void {
        Assert.assertEquals(0, signal.numListeners());
    }

    [Test(description="should have 1 listeners - length of 1")]
    public function add_one_listener():void {
        signal.add(listener);
        Assert.assertEquals(1, signal.numListeners());
    }

    [Test(description="should `has` listener")]
    public function has_listener():void {
        signal.add(listener);
        Assert.assertTrue(signal.has(listener));
    }

    [Test(description="should have second and third listeners")]
    public function has_second_and_third_listeners():void {
        signal.add(listener);
        signal.add(listener2);
        function listener3():void {
        }

        signal.add(listener3);
        Assert.assertTrue(signal.has(listener2), signal.has(listener3));
    }

    [Test(description="should have 1 listeners after adding 1 twice - length of 1")]
    public function add_one_listener_two_times():void {
        signal.add(listener);
        signal.add(listener);
        Assert.assertEquals(1, signal.numListeners());
    }

    [Test(description="should have 2 listeners - length of 2")]
    public function add_two_listeners():void {
        signal.add(listener);
        signal.add(listener2);
        Assert.assertEquals(2, signal.numListeners());
    }

    [Test(description="should dispatch twice (2 listeners)")]
    public function two_listeners_receive_signal():void {
        var count:int;
        signal.add(function lis1():void {
            ++count;
        });
        signal.add(function lis2():void {
            ++count;
        });
        signal.dispatch();

        Assert.assertEquals(2, count);
    }

    [Test(description="should have 0 listeners after removing")]
    public function remove_listener():void {
        signal.add(listener);
        signal.remove(listener);

        Assert.assertEquals(0, signal.numListeners());
    }

    [Test(description="should only dispatch listener once")]
    public function once_listener():void {
        var count:int;
        signal.add(function list():void {
            ++count;
        }, true);
        signal.dispatch();
        signal.dispatch();

        Assert.assertEquals(1, count);
    }

    [Test(description="once listener should receive dispatched argument")]
    public function once_listener_with_argument():void {
        var sprite:Sprite = new Sprite;
        signal.add(function list(spriteArg:Sprite):void {
            Assert.assertStrictlyEquals(sprite, spriteArg);
        }, true);
        signal.dispatch(sprite);
    }
}
}

/**
 * HexTest
 *
 * Tests for hex utility
 *
 * @author    Tim Kurvers <tim@moonsphere.net>
 */
package hu.vpmedia.crypt {
import flash.utils.ByteArray;

import flexunit.framework.Assert;

import hu.vpmedia.utils.ByteArrayUtil;

public class HexTest {

    [Test]
    public function toArray_test():void {
        var ba:ByteArray = new ByteArray();
        ba.writeByte(0x00);
        ba.writeByte(0xBA);
        ba.writeByte(0xDA);
        ba.writeByte(0x55);
        ba.writeByte(0x00);

        // Varied casing
        Assert.assertTrue(ByteArrayUtil.equals(Hex.toArray('00bada5500'), ba));
        Assert.assertTrue(ByteArrayUtil.equals(Hex.toArray('00BADA5500'), ba));

        // Without first nibble
        Assert.assertTrue(ByteArrayUtil.equals(Hex.toArray('0BADA5500'), ba));

        // Prefixed
        Assert.assertTrue(ByteArrayUtil.equals(Hex.toArray('0x00BADA5500'), ba));

        // Colon-laced
        Assert.assertTrue(ByteArrayUtil.equals(Hex.toArray('00:BA:DA:55:00'), ba));

        // Whitespaced
        Assert.assertTrue(ByteArrayUtil.equals(Hex.toArray('00 BA DA 55 00'), ba));
    }

    [Test]
    public function toArrayUTF_test():void {
        var ba:ByteArray = new ByteArray();
        ba.writeUTF("hello world");
        ba.position = 0;
        var hexFromArray:String = Hex.fromArray(ba);
        trace(hexFromArray);
        var baFromHex:ByteArray = Hex.toArray(hexFromArray);
        Assert.assertTrue(ByteArrayUtil.equals(baFromHex, ba));
    }

    [Test]
    public function fromArray_test():void {
        var ba:ByteArray = new ByteArray();
        ba.writeByte(0x00);
        ba.writeByte(0xBA);
        ba.writeByte(0xDA);
        ba.writeByte(0x55);
        ba.writeByte(0x00);

        Assert.assertEquals(Hex.fromArray(ba), '00bada5500');
    }

    [Test]
    public function toString_test():void {
        Assert.assertEquals(Hex.toString('61733363727970746f'), 'as3crypto');

        Assert.assertEquals(Hex.toString('e2b8ae'), '⸮');
        Assert.assertEquals(Hex.toRawString('e2b8ae'), 'â¸®');
    }

    [Test]
    public function fromString_test():void {
        Assert.assertEquals(Hex.fromString('as3crypto'), '61733363727970746f');

        Assert.assertEquals(Hex.fromString('⸮'), 'e2b8ae');
        Assert.assertEquals(Hex.fromRawString('â¸®'), 'e2b8ae');
    }
}

}

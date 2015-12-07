package hu.vpmedia.assets.parsers {
import app.TestAssets;

import flexunit.framework.Assert;

public class TXTParserTest {

    [Before]
    public function setUp():void {
    }

    [After]
    public function tearDown():void {
    }

    [Test]
    public function testParser():void {
        var parser:TXTParser = new TXTParser();
        var data:String = parser.parse(new TestAssets.TestTXT());
        Assert.assertTrue(data.indexOf("line2") > -1);
    }


}
}

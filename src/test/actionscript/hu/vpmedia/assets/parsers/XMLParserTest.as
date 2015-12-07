package hu.vpmedia.assets.parsers {
import app.TestAssets;

import flexunit.framework.Assert;

public class XMLParserTest {
    [Before]
    public function setUp():void {
    }

    [After]
    public function tearDown():void {
    }

    [Test]
    public function testParser():void {
        var parser:XMLParser = new XMLParser();
        var data:XML = parser.parse(new TestAssets.TestXML());
        Assert.assertTrue(data is XML);
    }


}
}
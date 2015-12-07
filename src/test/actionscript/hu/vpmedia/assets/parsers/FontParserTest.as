package hu.vpmedia.assets.parsers {
import flexunit.framework.Assert;

public class FontParserTest {

    [Before]
    public function setUp():void {
    }

    [After]
    public function tearDown():void {
    }

    [Test]
    public function testParser():void {
        var parser:FontSWFParser = new FontSWFParser();
        Assert.assertNotNull(parser);
    }


}
}

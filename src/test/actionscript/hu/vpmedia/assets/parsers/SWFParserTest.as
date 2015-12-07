package hu.vpmedia.assets.parsers {
import flexunit.framework.Assert;

public class SWFParserTest {

    [Before]
    public function setUp():void {
    }

    [After]
    public function tearDown():void {
    }

    [Test]
    public function testParser():void {
        var parser:SWFParser = new SWFParser();
        Assert.assertNotNull(parser);
    }


}
}

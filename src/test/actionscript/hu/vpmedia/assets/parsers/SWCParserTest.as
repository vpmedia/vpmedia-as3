package hu.vpmedia.assets.parsers {
import flexunit.framework.Assert;

public class SWCParserTest {

    [Before]
    public function setUp():void {
    }

    [After]
    public function tearDown():void {
    }

    [Test]
    public function testParser():void {
        var parser:SWCParser = new SWCParser();
        Assert.assertNotNull(parser);
    }


}
}

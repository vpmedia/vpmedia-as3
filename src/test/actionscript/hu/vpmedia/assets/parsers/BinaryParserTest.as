package hu.vpmedia.assets.parsers {
import flexunit.framework.Assert;

public class BinaryParserTest {
    [Before]
    public function setUp():void {
    }

    [After]
    public function tearDown():void {
    }

    [Test]
    public function testParser():void {
        var parser:BinaryParser = new BinaryParser();
        Assert.assertNotNull(parser);
    }


}
}
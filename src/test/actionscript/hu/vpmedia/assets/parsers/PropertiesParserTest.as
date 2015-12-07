package hu.vpmedia.assets.parsers {
import flexunit.framework.Assert;

public class PropertiesParserTest {

    [Before]
    public function setUp():void {
    }

    [After]
    public function tearDown():void {
    }

    [Test]
    public function testParser():void {
        var parser:PropertiesParser = new PropertiesParser();
        Assert.assertNotNull(parser);
    }


}
}

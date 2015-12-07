package hu.vpmedia.assets.parsers {
import flexunit.framework.Assert;

public class JSONParserTest {
    [Before]
    public function setUp():void {
    }

    [After]
    public function tearDown():void {
    }

    [Test]
    public function testParser():void {
        var parser:JSONParser = new JSONParser();
        var data:Object = parser.parse("{\"prop\":\"value\"}");
        Assert.assertTrue(data is Object);
        Assert.assertTrue(data.prop == "value");
    }


}
}
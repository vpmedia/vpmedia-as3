package hu.vpmedia.assets.parsers {
import flash.text.StyleSheet;

import flexunit.framework.Assert;

public class CSSParserTest {
    [Before]
    public function setUp():void {
    }

    [After]
    public function tearDown():void {
    }

    [Test]
    public function testParser():void {
        var parser:CSSParser = new CSSParser();
        var data:StyleSheet = parser.parse(".blank {value = true;}");
        Assert.assertTrue(data is StyleSheet);
    }


}
}
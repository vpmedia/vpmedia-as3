package hu.vpmedia.assets.parsers {
import app.TestAssets;

import hu.vpmedia.assets.AssetLoaderVO;

import org.osflash.signals.utils.proceedOnSignal;

public class ZIPParserTest {
    private var parser:ZIPParser;

    [Before]
    public function setUp():void {
        parser = new ZIPParser();
    }

    [After]
    public function tearDown():void {
        parser.dispose();
        parser = null;
    }

    [Test(async)]
    public function testParser():void {
        proceedOnSignal(this, parser.completed);
        parser.completed.add(onParserCompleted);
        parser.parseAsync(new TestAssets.TestZIP(), "test.zip");
    }

    private function onParserCompleted(parser:BaseAsyncAssetParser, items:Vector.<AssetLoaderVO>):void {
        trace(this, "onParserCompleted", parser, items);
    }


}
}

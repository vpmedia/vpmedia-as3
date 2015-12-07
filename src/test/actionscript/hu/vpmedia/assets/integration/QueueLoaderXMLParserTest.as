package hu.vpmedia.assets.integration {
import hu.vpmedia.assets.AssetLoader;
import hu.vpmedia.assets.integration.queueloader.QueueLoaderXMLParser;

import org.flexunit.asserts.assertTrue;

public class QueueLoaderXMLParserTest {
    private var xml:XML = <queueloader prefix="">
        <item container="null"
        src="test.zip">
            <info>
                <title>ZIP</title>
            </info>
        </item>
    </queueloader>;


    [Test]
    public function testParser():void {
        var loader:AssetLoader = new AssetLoader();
        QueueLoaderXMLParser.parseXML(loader, xml);
        assertTrue(loader.numTotal > 0);
    }


}
}
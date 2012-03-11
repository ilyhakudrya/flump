//
// Flump - Copyright 2012 Three Rings Design

package flump.xfl {

public class XflMovie extends XflTopLevelComponent
{
    use namespace xflns;

    public var libraryItem :String;
    public var symbol :String;
    public var layers :Array;

    public function XflMovie (baseLocation :String, xml :XML) {
        const converter :XmlConverter = new XmlConverter(xml);
        libraryItem = converter.getStringAttr("name");
        super(baseLocation + ":" + libraryItem);
        symbol = converter.getStringAttr("linkageClassName", null);

        const layerEls :XMLList = xml.timeline.DOMTimeline[0].layers.DOMLayer;
        if (new XmlConverter(layerEls[0]).getStringAttr("name") == "flipbook") {
            layers = [new XflLayer(location, layerEls[0], _errors, true)];
            if (symbol == null) {
                addError(ParseError.CRIT, "Flipbook movie '" + libraryItem + "' not exported");
            }
            for each (var kf :XflKeyframe in layers[0].keyframes) {
                kf.id = libraryItem + "_flipbook_" + kf.index;

            }
        } else {
            layers = new Array();
            for each (var layerEl :XML in layerEls) {
                if (new XmlConverter(layerEl).getStringAttr("layerType", "") != "guide") {
                    layers.unshift(new XflLayer(location, layerEl, _errors, false));
                }
            }
        }
    }

    public function checkSymbols (lib :XflLibrary) :void {
        if (flipbook && !lib.hasSymbol(symbol)) {
            addError(ParseError.CRIT, "Flipbook movie '" + symbol + "' not exported");
        } else for each (var layer :XflLayer in layers) layer.checkSymbols(lib);
    }

    public function get frames () :int {
        var frames :int = 0;
        for each (var layer :XflLayer in layers) frames = Math.max(frames, layer.frames);
        return frames;
    }

    public function get flipbook () :Boolean { return layers[0].flipbook; }

    public function toJSON (_:*) :Object {
        return {
            symbol: symbol,
            layers: layers
        };
    }

    public function toXML () :XML
    {
        var xml :XML = <movie name={libraryItem}/>
        for each (var layer :XflLayer in layers) {
            xml.appendChild(layer.toXML());
        }
        return xml;
    }
}
}

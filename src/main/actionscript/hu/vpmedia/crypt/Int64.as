package hu.vpmedia.crypt {
public class Int64 {
    public var h:int;
    public var l:int;

    public function Int64(h:int, l:int):void {
        this.h = h;
        this.l = l;
    }

    public function copy(src:Int64):void {
        this.h = src.h;
        this.l = src.l;
    }

    public function rrot(x:Int64, shift:int):void {
        this.l = (x.l >>> shift) | (x.h << (32 - shift));
        this.h = (x.h >>> shift) | (x.l << (32 - shift));
    }

    public function revrrot(x:Int64, shift:int):void {
        this.l = (x.h >>> shift) | (x.l << (32 - shift));
        this.h = (x.l >>> shift) | (x.h << (32 - shift));
    }

    public function shr(x:Int64, shift:int):void {
        this.l = (x.l >>> shift) | (x.h << (32 - shift));
        this.h = (x.h >>> shift);
    }

    public function add(x:Int64, y:Int64):void {
        var w0:uint = (x.l & 0xffff) + (y.l & 0xffff);
        var w1:uint = (x.l >>> 16) + (y.l >>> 16) + (w0 >>> 16);
        var w2:uint = (x.h & 0xffff) + (y.h & 0xffff) + (w1 >>> 16);
        var w3:uint = (x.h >>> 16) + (y.h >>> 16) + (w2 >>> 16);
        this.l = (w0 & 0xffff) | (w1 << 16);
        this.h = (w2 & 0xffff) | (w3 << 16);
    }

    public function add4(a:Int64, b:Int64, c:Int64, d:Int64):void {
        var w0:uint = (a.l & 0xffff) + (b.l & 0xffff) + (c.l & 0xffff) + (d.l & 0xffff);
        var w1:uint = (a.l >>> 16) + (b.l >>> 16) + (c.l >>> 16) + (d.l >>> 16) + (w0 >>> 16);
        var w2:uint = (a.h & 0xffff) + (b.h & 0xffff) + (c.h & 0xffff) + (d.h & 0xffff) + (w1 >>> 16);
        var w3:uint = (a.h >>> 16) + (b.h >>> 16) + (c.h >>> 16) + (d.h >>> 16) + (w2 >>> 16);
        this.l = (w0 & 0xffff) | (w1 << 16);
        this.h = (w2 & 0xffff) | (w3 << 16);
    }

    public function add5(a:Int64, b:Int64, c:Int64, d:Int64, e:Int64):void {
        var w0:uint = (a.l & 0xffff) + (b.l & 0xffff) + (c.l & 0xffff) + (d.l & 0xffff) + (e.l & 0xffff);
        var w1:uint = (a.l >>> 16) + (b.l >>> 16) + (c.l >>> 16) + (d.l >>> 16) + (e.l >>> 16) + (w0 >>> 16);
        var w2:uint = (a.h & 0xffff) + (b.h & 0xffff) + (c.h & 0xffff) + (d.h & 0xffff) + (e.h & 0xffff) + (w1 >>> 16);
        var w3:uint = (a.h >>> 16) + (b.h >>> 16) + (c.h >>> 16) + (d.h >>> 16) + (e.h >>> 16) + (w2 >>> 16);
        this.l = (w0 & 0xffff) | (w1 << 16);
        this.h = (w2 & 0xffff) | (w3 << 16);
    }
}
}
package hu.vpmedia.crypt {
public class SHA512 {
    private static var SHA512Vector:Vector.<Int64> = getSHA512Vector();

    private static function getSHA512Vector():Vector.<Int64> {
        var vector:Vector.<Int64> = new <Int64>[];
        vector.push(new Int64(0x428a2f98, -685199838));
        vector.push(new Int64(0x71374491, 0x23ef65cd));
        vector.push(new Int64(-1245643825, -330482897));
        vector.push(new Int64(-373957723, -2121671748));
        vector.push(new Int64(0x3956c25b, -213338824));
        vector.push(new Int64(0x59f111f1, -1241133031));
        vector.push(new Int64(-1841331548, -1357295717));
        vector.push(new Int64(-1424204075, -630357736));
        vector.push(new Int64(-670586216, -1560083902));
        vector.push(new Int64(0x12835b01, 0x45706fbe));
        vector.push(new Int64(0x243185be, 0x4ee4b28c));
        vector.push(new Int64(0x550c7dc3, -704662302));
        vector.push(new Int64(0x72be5d74, -226784913));
        vector.push(new Int64(-2132889090, 0x3b1696b1));
        vector.push(new Int64(-1680079193, 0x25c71235));
        vector.push(new Int64(-1046744716, -815192428));
        vector.push(new Int64(-459576895, -1628353838));
        vector.push(new Int64(-272742522, 0x384f25e3));
        vector.push(new Int64(0xfc19dc6, -1953704523));
        vector.push(new Int64(0x240ca1cc, 0x77ac9c65));
        vector.push(new Int64(0x2de92c6f, 0x592b0275));
        vector.push(new Int64(0x4a7484aa, 0x6ea6e483));
        vector.push(new Int64(0x5cb0a9dc, -1119749164));
        vector.push(new Int64(0x76f988da, -2096016459));
        vector.push(new Int64(-1740746414, -295247957));
        vector.push(new Int64(-1473132947, 0x2db43210));
        vector.push(new Int64(-1341970488, -1728372417));
        vector.push(new Int64(-1084653625, -1091629340));
        vector.push(new Int64(-958395405, 0x3da88fc2));
        vector.push(new Int64(-710438585, -1828018395));
        vector.push(new Int64(0x6ca6351, -536640913));
        vector.push(new Int64(0x14292967, 0xa0e6e70));
        vector.push(new Int64(0x27b70a85, 0x46d22ffc));
        vector.push(new Int64(0x2e1b2138, 0x5c26c926));
        vector.push(new Int64(0x4d2c6dfc, 0x5ac42aed));
        vector.push(new Int64(0x53380d13, -1651133473));
        vector.push(new Int64(0x650a7354, -1951439906));
        vector.push(new Int64(0x766a0abb, 0x3c77b2a8));
        vector.push(new Int64(-2117940946, 0x47edaee6));
        vector.push(new Int64(-1838011259, 0x1482353b));
        vector.push(new Int64(-1564481375, 0x4cf10364));
        vector.push(new Int64(-1474664885, -1136513023));
        vector.push(new Int64(-1035236496, -789014639));
        vector.push(new Int64(-949202525, 0x654be30));
        vector.push(new Int64(-778901479, -688958952));
        vector.push(new Int64(-694614492, 0x5565a910));
        vector.push(new Int64(-200395387, 0x5771202a));
        vector.push(new Int64(0x106aa070, 0x32bbd1b8));
        vector.push(new Int64(0x19a4c116, -1194143544));
        vector.push(new Int64(0x1e376c08, 0x5141ab53));
        vector.push(new Int64(0x2748774c, -544281703));
        vector.push(new Int64(0x34b0bcb5, -509917016));
        vector.push(new Int64(0x391c0cb3, -976659869));
        vector.push(new Int64(0x4ed8aa4a, -482243893));
        vector.push(new Int64(0x5b9cca4f, 0x7763e373));
        vector.push(new Int64(0x682e6ff3, -692930397));
        vector.push(new Int64(0x748f82ee, 0x5defb2fc));
        vector.push(new Int64(0x78a5636f, 0x43172f60));
        vector.push(new Int64(-2067236844, -1578062990));
        vector.push(new Int64(-1933114872, 0x1a6439ec));
        vector.push(new Int64(-1866530822, 0x23631e28));
        vector.push(new Int64(-1538233109, -561857047));
        vector.push(new Int64(-1090935817, -1295615723));
        vector.push(new Int64(-965641998, -479046869));
        vector.push(new Int64(-903397682, -366583396));
        vector.push(new Int64(-779700025, 0x21c0c207));
        vector.push(new Int64(-354779690, -840897762));
        vector.push(new Int64(-176337025, -294727304));
        vector.push(new Int64(0x6f067aa, 0x72176fba));
        vector.push(new Int64(0xa637dc5, -1563912026));
        vector.push(new Int64(0x113f9804, -1090974290));
        vector.push(new Int64(0x1b710b35, 0x131c471b));
        vector.push(new Int64(0x28db77f5, 0x23047d84));
        vector.push(new Int64(0x32caab7b, 0x40c72493));
        vector.push(new Int64(0x3c9ebe0a, 0x15c9bebc));
        vector.push(new Int64(0x431d67c4, -1676669620));
        vector.push(new Int64(0x4cc5d4be, -885112138));
        vector.push(new Int64(0x597f299c, -60457430));
        vector.push(new Int64(0x5fcb6fab, 0x3ad6faec));
        vector.push(new Int64(0x6c44198c, 0x4a475817));
        return vector;
    }

    private static function getHVector():Vector.<Int64> {
        var vector:Vector.<Int64> = new <Int64>[];
        vector.push(new Int64(0x6a09e667, -205731576));
        vector.push(new Int64(-1150833019, -2067093701));
        vector.push(new Int64(0x3c6ef372, -23791573));
        vector.push(new Int64(-1521486534, 0x5f1d36f1));
        vector.push(new Int64(0x510e527f, -1377402159));
        vector.push(new Int64(-1694144372, 0x2b3e6c1f));
        vector.push(new Int64(0x1f83d9ab, -79577749));
        vector.push(new Int64(0x5be0cd19, 0x137e2179));
        return vector;
    }

    public static function calculateHash(key:String, data:String):String {
        var bkey:Array = rstr2binb(key);
        if (bkey.length > 32) bkey = binb_sha512(bkey, key.length * 8);
        var ipad:Array = new Array(32);
        var opad:Array = new Array(32);
        for (var i:int = 0; i < 32; i++) {
            ipad[i] = bkey[i] ^ 0x36363636;
            opad[i] = bkey[i] ^ 0x5C5C5C5C;
        }
        var hash:Array = binb_sha512(ipad.concat(rstr2binb(data)), 1024 + data.length * 8);
        return binb2hex(binb_sha512(opad.concat(hash), 1024 + 512));
    }

    private static function binb2hex(input:Array):String {
        var hex_tab:String = "0123456789abcdef";
        var output:String = "";
        for (var i:int = 0; i < input.length * 32; i += 8) {
            var schar:int = (input[i >> 5] >>> (24 - i % 32)) & 0xFF;
            output += hex_tab.charAt((schar >>> 4) & 0x0F) + hex_tab.charAt(schar & 0x0F);
        }
        return output;
    }

    private static function rstr2binb(string:String):Array {
        var stringLength:int = string.length;
        var vectorLength:int = string.length >> 2;
        var result:Array = new Array(vectorLength);
        var i:int;
        for (i = 0; i < vectorLength; i++)
            result[i] = 0;
        for (i = 0; i < stringLength * 8; i += 8)
            result[i >> 5] |= (string.charCodeAt(i / 8) & 0xFF) << (24 - i % 32);
        return result;
    }

    private static function binb_sha512(x:Array, len:int):Array {
        var H:Vector.<Int64> = getHVector();

        var T1:Int64 = new Int64(0, 0);
        var T2:Int64 = new Int64(0, 0);
        var a:Int64 = new Int64(0, 0);
        var b:Int64 = new Int64(0, 0);
        var c:Int64 = new Int64(0, 0);
        var d:Int64 = new Int64(0, 0);
        var e:Int64 = new Int64(0, 0);
        var f:Int64 = new Int64(0, 0);
        var g:Int64 = new Int64(0, 0);
        var h:Int64 = new Int64(0, 0);

        var s0:Int64 = new Int64(0, 0);
        var s1:Int64 = new Int64(0, 0);
        var Ch:Int64 = new Int64(0, 0);
        var Maj:Int64 = new Int64(0, 0);
        var r1:Int64 = new Int64(0, 0);
        var r2:Int64 = new Int64(0, 0);
        var r3:Int64 = new Int64(0, 0);
        var j:int;
        var W:Vector.<Int64> = new Vector.<Int64>(80, true);
        for (var i:int = 0; i < 80; i++)
            W[i] = new Int64(0, 0);

        x[len >> 5] |= 0x80 << (24 - (len & 0x1f));
        x[((len + 128 >> 10) << 5) + 31] = len;
        for (i = 0; i < x.length; i += 32) {
            a.copy(H[0]);
            b.copy(H[1]);
            c.copy(H[2]);
            d.copy(H[3]);
            e.copy(H[4]);
            f.copy(H[5]);
            g.copy(H[6]);
            h.copy(H[7]);
            for (j = 0; j < 16; j++) {
                W[j].h = x[i + 2 * j];
                W[j].l = x[i + 2 * j + 1];
            }
            for (j = 16; j < 80; j++) {
                r1.rrot(W[j - 2], 19);
                r2.revrrot(W[j - 2], 29);
                r3.shr(W[j - 2], 6);
                s1.l = r1.l ^ r2.l ^ r3.l;
                s1.h = r1.h ^ r2.h ^ r3.h;
                r1.rrot(W[j - 15], 1);
                r2.rrot(W[j - 15], 8);
                r3.shr(W[j - 15], 7);
                s0.l = r1.l ^ r2.l ^ r3.l;
                s0.h = r1.h ^ r2.h ^ r3.h;
                W[j].add4(s1, W[j - 7], s0, W[j - 16]);
            }
            for (j = 0; j < 80; j++) {
                Ch.l = (e.l & f.l) ^ (~e.l & g.l);
                Ch.h = (e.h & f.h) ^ (~e.h & g.h);
                r1.rrot(e, 14);
                r2.rrot(e, 18);
                r3.revrrot(e, 9);
                s1.l = r1.l ^ r2.l ^ r3.l;
                s1.h = r1.h ^ r2.h ^ r3.h;
                r1.rrot(a, 28);
                r2.revrrot(a, 2);
                r3.revrrot(a, 7);
                s0.l = r1.l ^ r2.l ^ r3.l;
                s0.h = r1.h ^ r2.h ^ r3.h;
                Maj.l = (a.l & b.l) ^ (a.l & c.l) ^ (b.l & c.l);
                Maj.h = (a.h & b.h) ^ (a.h & c.h) ^ (b.h & c.h);
                T1.add5(h, s1, Ch, SHA512Vector[j], W[j]);
                T2.add(s0, Maj);
                h.copy(g);
                g.copy(f);
                f.copy(e);
                e.add(d, T1);
                d.copy(c);
                c.copy(b);
                b.copy(a);
                a.add(T1, T2);
            }
            H[0].add(H[0], a);
            H[1].add(H[1], b);
            H[2].add(H[2], c);
            H[3].add(H[3], d);
            H[4].add(H[4], e);
            H[5].add(H[5], f);
            H[6].add(H[6], g);
            H[7].add(H[7], h);
        }
        var hash:Array = new Array(16);
        for (i = 0; i < 8; i++) {
            hash[2 * i] = H[i].h;
            hash[2 * i + 1] = H[i].l;
        }
        return hash;
    }
}
}
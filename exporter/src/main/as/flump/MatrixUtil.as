//
// Flump - Copyright 2012 Three Rings Design

package flump {

import flash.geom.Matrix;

public class MatrixUtil
{
    public static function scaleX (m :Matrix) :Number
    {
        return sign(m.a) * Math.sqrt(m.a * m.a + m.b * m.b);
    }

    public static function setScaleX (m :Matrix, scaleX :Number) :void
    {
        var cur :Number = MatrixUtil.scaleX(m);
        if (cur != 0) {
            var scale :Number = scaleX / cur;
            m.a *= scale;
            m.b *= scale;
        } else {
            var skewY :Number = skewY(m);
            m.a = Math.cos(skewY) * scaleX;
            m.b = Math.sin(skewY) * scaleX;
        }
    }

    public static function scaleY (m :Matrix) :Number
    {
        return sign(m.d) * Math.sqrt(m.c * m.c + m.d * m.d);
    }

    public static function setScaleY (m :Matrix, scaleY :Number) :void
    {
        var cur :Number = MatrixUtil.scaleY(m);
        if (cur != 0) {
            var scale :Number = scaleY / cur;
            m.c *= scale;
            m.d *= scale;
        } else {
            var skewX :Number = skewX(m);
            m.c = -Math.sin(skewX) * scaleY;
            m.d = Math.cos(skewX) * scaleY;
        }
    }

    public static function skewX (m :Matrix) :Number
    {
        return Math.atan2(-m.c, m.d);
    }

    public static function setSkewX (m :Matrix, skewX :Number) :void
    {
        var scaleY :Number = MatrixUtil.scaleY(m);
        m.c = -scaleY * Math.sin(skewX);
        m.d = scaleY * Math.cos(skewX);
    }

    public static function skewY (m :Matrix) :Number
    {
        return Math.atan2(m.b, m.a);
    }

    public static function setSkewY (m :Matrix, skewY :Number) :void
    {
        var scaleX :Number = MatrixUtil.scaleX(m);
        m.a = scaleX * Math.cos(skewY);
        m.b = scaleX * Math.sin(skewY);
    }

    public static function rotation (m :Matrix) :Number
    {
        return (m.a == 0) ? 0 : Math.atan(m.b / m.a);
    }

    public static function setRotation (m :Matrix, rotation :Number) :void
    {
        var curRotation :Number = MatrixUtil.rotation(m);
        var curSkewX :Number = MatrixUtil.skewX(m);
        MatrixUtil.setSkewX(m, curSkewX + rotation - curRotation);
        MatrixUtil.setSkewY(m, rotation);
    }

    protected static function sign (value :Number) :Number
    {
        return (value < 0) ? -1 : (value > 0) ? 1 : 0;
    }
}
}
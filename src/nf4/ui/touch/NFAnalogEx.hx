package nf4.ui.touch;

import flixel.ui.FlxAnalog;
import flixel.system.FlxAssets;
import flixel.math.FlxAngle;

class NFAnalogEx extends FlxAnalog {

    public function new(X:Float = 0, Y:Float = 0, Radius:Float = 0, Ease:Float = 0.25, ?BaseGraphic:FlxGraphicAsset, ?ThumbGraphic:FlxGraphicAsset) {
        super(X, Y, Radius, Ease, BaseGraphic, ThumbGraphic);
    }

    private var directionAngleThreshold:Float = Math.PI / 3;

    public var left(get, null):Bool;
    public var up(get, null):Bool;
    public var right(get, null):Bool;
    public var down(get, null):Bool;

    private function get_left():Bool {
        return inAngleThreshold(Math.PI);
    }

    private function get_up():Bool {
        return inAngleThreshold(-Math.PI / 2);
    }

    private function get_right():Bool {
        return inAngleThreshold(0);
    }

    private function get_down():Bool {
        return inAngleThreshold(Math.PI / 2);
    }

    private function inAngleThreshold(TargetAngle:Float) {
        var angle = this._direction;
        if (angle < 0) angle += 2 * Math.PI;
        var diff = Math.abs(angle - TargetAngle) % (Math.PI * 2);
        if (diff > Math.PI) diff = Math.PI * 2 - diff;
        return diff < directionAngleThreshold;
    }
}
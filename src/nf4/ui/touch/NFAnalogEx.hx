package nf4.ui.touch;

import flixel.ui.FlxAnalog;
import flixel.system.FlxAssets;

class NFAnalogEx extends FlxAnalog {

    public function new(X:Float = 0, Y:Float = 0, Radius:Float = 0, Ease:Float = 0.25, ?BaseGraphic:FlxGraphicAsset, ?ThumbGraphic:FlxGraphicAsset) {
        super(X, Y, Radius, Ease, BaseGraphic, ThumbGraphic);
    }

    private var directionAngleThreshold:Float = 60;

    public var left(get, null):Bool;
    public var up(get, null):Bool;
    public var right(get, null):Bool;
    public var down(get, null):Bool;

    private function get_left():Bool {
        return Math.abs(getAngle() - 180) < directionAngleThreshold;
    }

    private function get_up():Bool {
        return Math.abs(getAngle() - 270) < directionAngleThreshold;
    }

    private function get_right():Bool {
        return Math.abs(getAngle() - 0) < directionAngleThreshold;
    }

    private function get_down():Bool {
        return Math.abs(getAngle() - 90) < directionAngleThreshold;
    }

}
package nf4.input;

import flixel.math.*;
import flixel.input.gamepad.*;

class NFGamepad {

    private var gamepad:FlxGamepad;

    public function new(Gamepad:FlxGamepad) {
        gamepad = Gamepad;
    }

    public static function get(Gamepad:FlxGamepad):NFGamepad {
        if (Gamepad == null) return null;
        return new NFGamepad(Gamepad);
    }

    public function getAxes(AxesButtonID:FlxGamepadInputID, DeadzoneRadius:Float = 0.2) {
        var axisVec = FlxVector.get(gamepad.getXAxis(AxesButtonID), gamepad.getYAxis(AxesButtonID));
        if (axisVec.length < DeadzoneRadius) axisVec.set(0, 0);
        return axisVec;
    }

}
package nf4.ui;

import flixel.*;
import flixel.util.*;

import nf4.ui.menu.*;

class NFFlatButton extends NFMenuItem {

    private var defaultForegroundColor:FlxColor = FlxColor.fromInt(0xAAEEEEEE);
    private var defaultBackgroundColor:FlxColor = FlxColor.fromInt(0xAA222222);

    public function new(?X:Float = 0, ?Y:Float = 0, ?Width:Int = 200, ?Text:NFText, ?OnClick:Void->Void) {
        super(Text, Width, OnClick);

        updatePosition(X - Text.width / 2, Y);
        updateTheme(defaultForegroundColor, defaultBackgroundColor);
    }

    public function screenCenter(?axes:FlxAxes) {
		if (axes == null)
			axes = FlxAxes.XY;
		
		if (axes != FlxAxes.Y) {
            updatePosition((FlxG.width / 2), y);
        }
		if (axes != FlxAxes.X) {
			updatePosition(x + width / 2, ((FlxG.height / 2) - (height / 2)));
        }
	}

}
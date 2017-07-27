package nf4.ui.touch;

import flixel.*;

class NFPauseButton extends FlxSprite {

    public function new(?X:Float, ?Y:Float, Opacity:Float = 0.7, Scale:Float = 1.0) {
        super(X, Y);

        loadGraphic(NF4AssetPaths.nf4_ui_pause__png);
        alpha = 0.7;
        scale.set(Scale, Scale);
    }

    public function isPressed():Bool {
        var press:Bool = false;


        #if !FLX_NO_MOUSE
        var mousePos = FlxG.mouse.getPositionInCameraView(cameras[0]);
        press = press || FlxG.mouse.justPressed && this.getBoundingBox(cameras[0]).containsPoint(mousePos);
        #end


        #if !FLX_NO_TOUCH
        var touch = FlxG.touches.getFirst();
        if (touch != null && touch.justPressed) {
            press = press || this.getBoundingBox(cameras[0]).containsPoint(touch);
        }
        #end

        return press;
    }

}
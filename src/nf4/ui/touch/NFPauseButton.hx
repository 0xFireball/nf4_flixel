package nf4.ui.touch;

import flixel.*;

class NFPauseButton extends FlxSprite {

    public function new(?X:Float, ?Y:Float, Opacity:Float = 0.7) {
        super(X, Y);

        loadGraphic(NF4AssetPaths.nf4_ui_pause__png);
        alpha = 0.7;
    }

    public function isPressed():Bool {
        var press:Bool = false;

        var mousePos = FlxG.mouse.getPositionInCameraView(cameras[0]);

        #if !FLX_NO_MOUSE
        press = press || mousePos.x > this.x && mousePos.x < this.x + this.width
            && mousePos.y > this.y && mousePos.y < this.y + this.height;
        #end


        #if !FLX_NO_TOUCH
        var touch = FlxG.touches.getFirst();
        if (touch != null) {
            press = press || touch.x > this.x && touch.x < this.x + this.width
            && touch.y > this.y && touch.y < this.y + this.height;
        }
        #end

        return press;
    }

}
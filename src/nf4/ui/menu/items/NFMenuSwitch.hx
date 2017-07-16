package nf4.ui.menu.items;

import flixel.*;
import flixel.tweens.*;
import flixel.util.*;

import nf4.ui.menu.*;

class NFMenuSwitch extends NFMenuItem {

    private var items:Array<String>;
    private var selectedIndex:Int;
    private var arrowMarginFactor:Float = 0.2;

    private var leftArrow:FlxSprite;
    private var rightArrow:FlxSprite;

    public function new(TextContainer:NFText, Items:Array<String>, Width:Float, SelectedIndex:Int = 0, ?SelectCallback:Void->Void) {
        TextContainer.text = Items[SelectedIndex];
        super(TextContainer, Width, SelectCallback);

        items = Items;
        selectedIndex = SelectedIndex;

        rightArrow = new FlxSprite();
        rightArrow.loadGraphic(NF4AssetPaths.nf4_ui_arrow__png);

        leftArrow = new FlxSprite();
        leftArrow.loadGraphic(NF4AssetPaths.nf4_ui_arrow__png);
        leftArrow.setFacingFlip(FlxObject.LEFT, true, false);
        leftArrow.facing = FlxObject.LEFT;

        add(rightArrow);
        add(leftArrow);
    }

    public override function updatePosition(CenterX:Float, Y:Float) {
        super.updatePosition(CenterX, Y);
        
        leftArrow.x = backing.x  + backing.width * arrowMarginFactor;
        rightArrow.x = backing.x + backing.width * (1 - arrowMarginFactor) - rightArrow.width;
    }

    public override function update(dt:Float) {
        super.update(dt);

        if (selected) {
            // handle switching
            var left:Bool = false;
            var right:Bool = false;
            
            #if !FLX_NO_KEYBOARD
            left = FlxG.keys.anyJustPressed([LEFT, A]);
            right = FlxG.keys.anyJustPressed([RIGHT, D]);
            #end

            #if !FLX_NO_GAMEPAD
            var gamepad = FlxG.gamepads.lastActive;
            if (gamepad != null) {
                left = left || gamepad.anyJustPressed([ DPAD_LEFT ]);
                right = right || gamepad.anyJustPressed([ DPAD_RIGHT ]);
            }
            #end

            if (left || right) {
                if (left) {
                    selectedIndex--;
                } else if (right) {
                    selectedIndex++;
                }

                if (selectedIndex < 0) selectedIndex += items.length;
                if (selectedIndex >= items.length) selectedIndex %= items.length;

                // update text
                text.text = items[selectedIndex];
            }            
        }
    }

}
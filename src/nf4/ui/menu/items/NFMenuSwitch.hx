package nf4.ui.menu.items;

import flixel.*;
import flixel.tweens.*;
import flixel.util.*;

import nf4.ui.menu.*;

class NFMenuSwitch extends NFMenuItem {

    private var items:Array<String>;
    private var selectedIndex:Int;
    private var arrowMarginFactor:Float = 0.01;

    private var inactiveArrowAlpha:Float = 0.2;
    private var activeArrowAlpha:Float = 0.5;

    private var leftArrow:FlxSprite;
    private var rightArrow:FlxSprite;

    private var lArrowTween:FlxTween;
    private var rArrowTween:FlxTween;

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

        leftArrow.alpha = rightArrow.alpha = inactiveArrowAlpha;

        // put the arrows behind the text, which is layer 2
        insert(2, rightArrow);
        insert(2, leftArrow);
    }

    public override function updatePosition(CenterX:Float, Y:Float) {
        super.updatePosition(CenterX, Y);

        leftArrow.y = rightArrow.y = Y + backing.height / 2 - leftArrow.height / 2;
        leftArrow.x = backing.x  + backing.width * arrowMarginFactor;
        rightArrow.x = backing.x + backing.width * (1 - arrowMarginFactor) - rightArrow.width;
    }

    private override function onSelect(Now:Bool = false) {
        super.onSelect(Now);

        if (Now) {
            leftArrow.alpha = rightArrow.alpha = activeArrowAlpha;
        } else {
            lArrowTween = alphaTween(leftArrow, activeArrowAlpha);
            rArrowTween = alphaTween(rightArrow, activeArrowAlpha);
        }
    }

    private override function onDeselect(Now:Bool = false) {
        super.onDeselect(Now);

        if (Now) {
            leftArrow.alpha = rightArrow.alpha = inactiveArrowAlpha;
        } else {
            lArrowTween = alphaTween(leftArrow, inactiveArrowAlpha);
            rArrowTween = alphaTween(rightArrow, inactiveArrowAlpha);
        }
    }

    private override function anyTweens() {
        return super.anyTweens()
            || (lArrowTween != null && !lArrowTween.finished)
            || (rArrowTween != null && !rArrowTween.finished);
    }

    private override function cancelTweens() {
        super.cancelTweens();
        if (lArrowTween != null) lArrowTween.cancel();
        if (rArrowTween != null) rArrowTween.cancel();
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
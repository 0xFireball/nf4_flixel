package nf4.ui.menu.items;

import flixel.*;
import flixel.tweens.*;
import flixel.util.*;

import nf4.ui.menu.*;

class NFMenuInput extends NFMenuItem {

    public static inline var NO_FILTER:Int			= 0;
	public static inline var ONLY_ALPHA:Int			= 1;
	public static inline var ONLY_NUMERIC:Int		= 2;
	public static inline var ONLY_ALPHANUMERIC:Int	= 3;
	public static inline var CUSTOM_FILTER:Int		= 4;
	
	public static inline var ALL_CASES:Int			= 0;
	public static inline var UPPER_CASE:Int			= 1;
	public static inline var LOWER_CASE:Int			= 2;

    private var inputValue:String;
    
    private var cursorAlpha:Float = 0.8;
    private var inactiveCursorAlpha:Float = 0.2;

    private var cursor:FlxSprite;
    private var caretIndex:Int = 0;

    private var maxLength:Int = 0;

    private var cursorTween:FlxTween;

    private var textChangedCallback:String->Void;

    public function new(TextContainer:NFText, Value:String = "", Width:Float, ?MaxLength:Int = 0, ?SelectCallback:Void->Void, ?TextChangedCallback:String->Void) {
        TextContainer.text = inputValue = Value;
        super(TextContainer, Width, SelectCallback);

        maxLength = MaxLength;

        textChangedCallback = TextChangedCallback;

        onTextChanged();

        cursor = new FlxSprite();
        cursor.loadGraphic(NF4AssetPaths.nf4_ui_input_cursor__png);
        cursor.alpha = cursorAlpha;

        keyNavigation = false;

        // insert(2, cursor);
    }

    public override function updatePosition(CenterX:Float, Y:Float) {
        super.updatePosition(CenterX, Y);
        text.x = (CenterX) - (backing.width / 2) * (1 - marginFactor);
        updateCursorPosition();
    }

    private function updateCursorPosition() {
        
    }

    public function setValue(val:String) {
        text.text = inputValue = val;
    }

    private override function onSelect(Now:Bool = false) {
        super.onSelect(Now);

        if (Now) {
            cursor.alpha = cursorAlpha;
        } else {
            cursorTween = alphaTween(cursor, cursorAlpha);
        }
    }

    private override function onDeselect(Now:Bool = false) {
        super.onDeselect(Now);

        if (Now) {
            cursor.alpha = inactiveCursorAlpha;
        } else {
            cursorTween = alphaTween(cursor, inactiveCursorAlpha);
        }
    }

    public override function activate() {
        super.activate();
    }

    private override function anyTweens() {
        return super.anyTweens()
            || (cursorTween != null && !cursorTween.finished);
    }

    private override function cancelTweens() {
        super.cancelTweens();
        if (cursorTween != null) cursorTween.cancel();
    }

    public override function update(dt:Float) {
        super.update(dt);

        if (selected) {
            #if !FLX_NO_KEYBOARD
            var pressedKeyId:flixel.input.keyboard.FlxKey = FlxG.keys.firstJustPressed();
            onKeyDown(pressedKeyId);
            #end
        }
    }

    private function onTextChanged() {
        // fire callback
        if (textChangedCallback != null) {
            textChangedCallback(inputValue);
        }
    }

    /**
	 * Handles keypresses generated on the stage.
	 */
	private function onKeyDown(key:flixel.input.keyboard.FlxKey):Void 
	{
        // Do nothing for Shift, Ctrl, Esc, and flixel console hotkey
        if (key == 16 || key == 17 || key == 220 || key == 27) 
        {
            return;
        }
        // Left arrow
        else if (key == 37) 
        { 
            if (caretIndex > 0) { 
                caretIndex--;
                // text = text; // forces scroll update
            }
        }
        // Right arrow
        else if (key == 39) 
        { 
            if (caretIndex < inputValue.length) {
                caretIndex++;
                // text = text; // forces scroll update
            }
        }
        // End key
        else if (key == 35) 
        {
            caretIndex = inputValue.length;
            // text.text = text.text; // forces scroll update
        }
        // Home key
        else if (key == 36)
        {
            caretIndex = 0;
            // text = text;
        }
        // Backspace
        else if (key == 8) 
        {
            // if (caretIndex > 0) 
            // {
            //     caretIndex--;
            //     text = text.substring(0, caretIndex) + text.substring(caretIndex + 1 );
            //     onChange(BACKSPACE_ACTION);
            // }
            caretIndex--;
            inputValue = inputValue.substring(0, caretIndex) + inputValue.substring(caretIndex + 1);
        }
        // Delete
        else if (key == 46)
        {
            // if (text.length > 0 && caretIndex < text.length) 
            // {
            //     text = text.substring(0, caretIndex) + text.substring(caretIndex + 1);
            //     onChange(DELETE_ACTION);
            // }
        }
        // Enter
        else if (key == 13) 
        {
            // onChange(ENTER_ACTION);
        }
        // Actually add some text
        else
        {
            if (key == -1 || key == 0) return;
            var keyStr = filter(String.fromCharCode(key));
            if (keyStr != null && (maxLength == 0 || inputValue.length < maxLength)) {
                inputValue += keyStr;
                caretIndex++;
            }
        }
        // update text
        text.text = inputValue;
        // update cursor
        updateCursorPosition();
        onTextChanged();
    }

    /**
	 * Checks an input string against the current 
	 * filter and returns a filtered string
	 */
	private function filter(text:String):String
	{
		// if (forceCase == UPPER_CASE)
		// {
		// 	text = text.toUpperCase();
		// }
		// else if (forceCase == LOWER_CASE)
		// {
		// 	text = text.toLowerCase();
		// }

        var filterMode = ONLY_ALPHANUMERIC;

        var pattern:EReg = null;
        switch(filterMode)
        {
            case ONLY_ALPHA:		pattern = ~/[^a-zA-Z]*/g;
            case ONLY_NUMERIC:		pattern = ~/[^0-9]*/g;
            case ONLY_ALPHANUMERIC:	pattern = ~/[^a-zA-Z0-9]*/g;
            // case CUSTOM_FILTER:		pattern = customFilterPattern;
            // default:
            //     throw "Unknown filterMode (" + filterMode + ")";
        }
        text = pattern.replace(text, "");

		return text;
	}

}
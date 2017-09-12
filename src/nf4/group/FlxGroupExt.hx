package nf4.group;

import flixel.group.FlxGroup;

class FlxGroupExt extends FlxGroup {

    public var memberCount(get, null):Int;

    public function new(MaxSize:Int = 0) {
        super(MaxSize);
    }

    private function get_memberCount():Int {
        return this.length;
    }
}
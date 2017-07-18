
package nf4;

import flixel.FlxSprite;
import flixel.math.*;

using nf4.math.NFMathExt;

class NFSprite extends FlxSprite {

    /**
     *  Utility for setting health by percentages.
	 *  For example, setting `damage` to 0.2 will
	 *  set the `health` to 80% of `maxHealth`.
     */
    public var damage(get, set):Float;

	/**
	 *  Utility for getting the center of the sprite
	 *  based on its x, y, width, and height.
	 */
	public var center(get, null):FlxPoint;

	/**
	 *  Utility for getting a momentum vector based
	 *  on the sprite's velocity and mass.
	 */
	public var momentum(get, null):FlxVector;

    /**
	 * Utility for storing maximum health.
	 */
	public var maxHealth:Float = 1;

	/**
	 *  Sub-sprites are handy for attaching other
	 *  sprites to this sprite, like a FlxEmitter.
	 *  The subsprites will follow the same lifecycle
	 *  as this sprite, except dead subsprites will be destroyed.
	 */
	public var subSprites:FlxGroup;

    public function new(?X:Float = 0, ?Y:Float = 0) {
        super(X, Y);

        damage = 0;
		subSprites = new FlxGroup();
    }

	public function apply_impulse(Direction:FlxPoint, Magnitude:Float) {
		velocity.addPoint(Direction.scale(Magnitude / mass));
	}

	public override function update(dt:Float) {
		subSprites.update(dt);

		// nuke dead subsprites
		subSprites.forEachDead(function (d) {
			subSprites.remove(d, true);
			d.destroy();
		});

		super.update(dt);
    }

    public override function draw():Void {
		super.draw();

		subSprites.draw();
	}

    public override function kill() {
		super.kill();
		subSprites.kill();
	}

    public override function destroy() {
		subSprites.destroy();
		subSprites = null;

        super.destroy();
    }

	public function explode() {
		dismantle();
	}

	public function dismantle() {
		this.kill();
	}

    private function get_damage():Float {
		var mHealth = health < 0 ? 0 : health;
		return 1 - (mHealth / maxHealth);
	}

	private function set_damage(f:Float):Float {
		health = (1 - f) * maxHealth;
		return damage;
	}

	private function get_center():FlxPoint {
		return FlxPoint.get(x + width / 2, y + height / 2);
	}

	private function get_momentum():FlxVector {
		return velocity.toVector().scale(mass);
	}
}

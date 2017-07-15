
package nf4;

import flixel.FlxSprite;
import flixel.math.*;

import flixel.addons.nape.FlxNapeSprite;

using nf4.math.NFMathExt;

class NFNapeSprite extends FlxNapeSprite {
    public var damage(get, set):Float;

	public var center(get, null):FlxPoint;

	public var momentum(get, null):FlxVector;

    /**
	 * Utility for storing maximum health
	 */
	public var maxHealth:Float = 1;

    public function new(?X:Float = 0, ?Y:Float = 0) {
        super(X, Y);
        damage = 0;
    }

	public function apply_impulse(Direction:FlxPoint, Magnitude:Float) {
		velocity.addPoint(Direction.scale(Magnitude / mass));
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

	public override function update(dt:Float) {
		super.update(dt);

		// apply custom kinematics
		applyCustomKinematics(dt);
	}

	private function applyCustomKinematics(dt:Float) {
		var velocityDelta = 0.5 * (FlxVelocity.computeVelocity(FlxAngle.asDegrees(body.angularVel), angularAcceleration, angularDrag, maxAngular, dt) - FlxAngle.asDegrees(body.angularVel));
		// angularVelocity += velocityDelta;
		// angle += body.angularVel * dt;
		// angularVelocity += velocityDelta;
		body.angularVel += 2 * FlxAngle.asRadians(velocityDelta);
	}
}

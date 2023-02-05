package states;

import flixel.FlxState;
import sprites.CSS;
import sprites.CharacterSlot;

// trying to figure out why the fps is low, and also why memory keeps increasing
class TestState extends FlxState
{
	override function create()
	{
		super.create();

		/*var slot = new CharacterSlot(0, 0, 'mario');
			add(slot);
			var slot2 = new CharacterSlot(0.1, 0.1, 'link');
			add(slot2); */

		var _css = new CSS(0, 0, Paths.crusadeData('data/css.txt'));
		add(_css);
	}
}

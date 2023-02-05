package data;

import flixel.util.FlxStringUtil;

using StringTools;

class CharacterData
{
	public static var characters:Map<String, Character> = new Map();
	public static var characterIDs:Map<Int, Character> = new Map();
	public static var characterForms:Map<String, CharacterForm> = new Map();
	public static var characterLock:Array<String> = [];
	public static var defaultCharacters:Map<String, Character> = [
		'mario' => new Character('mario', 'Mario', 'Mario', 'Mario', 'mario', 1),
		'pika' => new Character('pika', 'Pikachu', 'Pikachu', 'Pikachu', 'pokemon', 2),
		'ryu' => new Character('ryu', 'Ryu', 'Ryu (Metsu Hadoken)', 'Ryu', 'sf', 3),
		'tails_cake' => new Character('tails_cake', 'Tails', 'Miles "Tails" Prower', 'Miles "Tails" Prower', 'sonic', 4),
		'luigi' => new Character('luigi', 'Luigi', 'Luigi', 'Luigi', 'mario', 5),
		'falco' => new Character('falco', 'Falco', 'Falco', 'Falco', 'starfox', 6),
		'gooey' => new Character('gooey', 'Gooey', 'Gooey', 'Gooey', 'kirby', 7),
		'purin' => new Character('purin', 'Jigglypuff', 'Jigglypuff', 'Jigglypuff', 'pokemon', 8),
		'samus' => new Character('samus', 'Samus', 'Samus', 'Samus', 'metroid', 9),
		'lucario' => new Character('lucario', 'Lucario', 'Lucario (Aura)', 'Lucario', 'pokemon', 10),
		'snivy' => new Character('snivy', 'Snivy', 'Snivy', 'Snivy', 'pokemon', 11),
		'sonic' => new Character('sonic', 'Sonic', 'Sonic', 'Sonic', 'sonic', 12),
		'chunli' => new Character('chunli', 'Chun-Li', 'Chun-Li (Kikosho)', 'Chun-Li', 'sf', 13),
		'goku' => new Character('goku', 'Goku', 'Goku', 'Goku', 'dbz', 14),
		'mrgw' => new Character('mrgw', 'Mr. G&W', 'Mr. Game&Watch', 'Mr. Game&Watch', 'gw', 15),
		'marth' => new Character('marth', 'Marth', 'Marth (Tipper)', 'Marth', 'fe', 16),
		'link' => new Character('link', 'Link', 'Link (Items)', 'Link', 'zelda', 17),
		'snake' => new Character('snake', 'Snake', 'Solid Snake', 'Solid Snake', 'mg', 18),
		'peach' => new Character('peach', 'Peach', 'Peach', 'Peach', 'mario', 19),
		'wario' => new Character('wario', 'Wario', 'Wario', 'Wario', 'wario', 20),
		'mega' => new Character('mega', 'Mega Man', 'Mega Man', 'Mega Man', 'megaman', 21),
		'yoshi' => new Character('yoshi', 'Yoshi', 'Yoshi', 'Yoshi', 'yoshi', 22),
		'falcon' => new Character('falcon', 'C. Falcon', 'Captain Falcon', 'Captain Falcon', 'fzero', 23),
		'wright' => new Character('wright', 'P. Wright', 'Phoenix Wright', 'Phoenix Wright', 'attorney', 24),
		'ridley' => new Character('ridley', 'Ridley', 'Ridley', 'Ridley', 'metroid', 25),
		'porky' => new Character('porky', 'Porky', 'Porky Minch', 'Porky Minch', 'mother', 26),
		'dhd' => new Character('dhd', 'DHD', 'Duck Hunt Dog', 'Duck Hunt Dog', 'dhunt', 27),
		'bomber' => new Character('bomber', 'Bomberman', 'Bomberman', 'Bomberman', 'bomber', 28),
		'geno' => new Character('geno', 'Geno', 'Geno', 'Geno', 'mario', 29),
		'metaknight' => new Character('metaknight', 'Meta Knight', 'Meta Knight', 'Meta Knight', 'kirby', 30),
		'saki' => new Character('saki', 'Saki', 'Saki Amamiya', 'Saki Amamiya', 'sin', 31),
		'waluigi' => new Character('waluigi', 'Waluigi', 'Waluigi', 'Waluigi', 'mario', 32),
		'fox' => new Character('fox', 'Fox', 'Fox', 'Fox', 'starfox', 33),
		'clink' => new Character('clink', 'Toon Link', 'Toon Link', 'Toon Link', 'zelda', 34),
		'lucas' => new Character('lucas', 'Lucas', 'Lucas', 'Lucas', 'mother', 35),
		'ristar' => new Character('ristar', 'Ristar', 'Ristar', 'Ristar', 'ristar', 36),
		'ness' => new Character('ness', 'Ness', 'Ness', 'Ness', 'mother', 37),
		'mew2' => new Character('mew2', 'Mewtwo', 'Mewtwo', 'Mewtwo', 'pokemon', 38),
		'krystal' => new Character('krystal', 'Krystal', 'Krystal', 'Krystal', 'starfox', 39),
		'dk' => new Character('dk', 'DK', 'Donkey Kong', 'Donkey Kong', 'dk', 40),
		'rayman' => new Character('rayman', 'Rayman', 'Rayman', 'Rayman', 'rayman', 41),
		'mach' => new Character('mach', 'Mach Rider', 'Mach Rider', 'Mach Rider', 'mrider', 42),
		'shadow' => new Character('shadow', 'Shadow', 'Shadow', 'Shadow', 'sonic', 43),
		'knux' => new Character('knux', 'Knuckles', 'Knuckles', 'Knuckles', 'sonic', 44),
		'kirby' => new Character('kirby', 'Kirby', 'Kirby', 'Kirby', 'kirby', 45),
		'toad' => new Character('toad', 'Toad', 'Toad', 'Toad', 'mario', 46),
		'ganon' => new Character('ganon', 'Ganondorf', 'Ganondorf', 'Ganondorf', 'zelda', 47),
		'climbers' => new Character('climbers', 'Ice Climbers', 'Ice Climbers (Duo)', 'Ice Climbers', 'ic', 48),
		'rob' => new Character('rob', 'R.O.B.', 'R.O.B.', 'R.O.B.', 'rob', 49),
		'ashley' => new Character('ashley', 'Ashley', 'Ashley', 'Ashley', 'wario', 50),
		'petey' => new Character('petey', 'Petey', 'Petey Piranha', 'Petey Piranha', 'mario', 51),
		'pacman' => new Character('pacman', 'Pac-Man', 'Pac-Man', 'Pac-Man', 'pacman', 52),
		'bowser' => new Character('bowser', 'Bowser', 'Bowser', 'Bowser', 'mario', 53),
		'olimar' => new Character('olimar', 'Olimar', 'Pikmin & Olimar', 'Pikmin & Olimar', 'pikmin', 54),
		'tingle' => new Character('tingle', 'Tingle', 'Tingle', 'Tingle', 'tingle', 55),
		'mac' => new Character('mac', 'Little Mac', 'Little Mac (Crusade)', 'Little Mac', 'pnchout', 56),
		'crash' => new Character('crash', 'Crash', 'Crash Bandicoot', 'Crash', 'crash', 57),
		'klonoa' => new Character('klonoa', 'Klonoa', 'Klonoa', 'Klonoa', 'klonoa', 58),
		'pichu' => new Character('pichu', 'Pichu', 'Pichu', 'Pichu', 'pokemon', 59),
		'sprite' => new Character('sprite', 'Fighting Sprite', 'Fighting Sprite', 'Fighting Sprite', 'ssb', 60),
		'hand' => new Character('hand', 'Master Hand', 'Master Hand', 'Master Hand', 'ssb', 61),
		'drmario' => new Character('drmario', 'Dr. Mario', 'Dr. Mario', 'Dr. Mario', 'mario', 62),
		'shantae' => new Character('shantae', 'Shantae', 'Shantae', 'Shantae', 'shantae', 63),
		'nega' => new Character('nega', 'Nega Shantae', 'Nega Shantae', 'Nega Shantae', 'shantae', 64),
		'evil' => new Character('evil', 'Evil Ryu', 'Evil Ryu (Shinku Tatsumaki)', 'Evil Ryu', 'sf', 65)
	];

	public static function reloadCharacters()
	{
		characters.clear();
		characterIDs.clear();
		characterIDs.set(0, new Character('', '', '', '', '', 0));
		characterIDs.set(9999, new Character('random', 'Random', 'Random', 'Random', '', 9999));
		characterLock.resize(0);
		characterLock.push('hand');
		characterLock.push('sprite');

		var nextID:Int = 1;
		for (key => char in defaultCharacters)
		{
			characters.set(key, char);
			characterIDs.set(char.id, char);
			nextID++;
		}
		var fighters = Paths.crusadeData('data/fighters.txt');
		if (!FlxStringUtil.isNullOrEmpty(fighters))
		{
			var splitFighters = Util.getSplitText(fighters);

			var fighterLockData = Paths.crusadeData('data/fighter_lock.txt');
			if (!FlxStringUtil.isNullOrEmpty(fighterLockData))
			{
				var splitFighterLock = Util.getSplitText(fighterLockData);
				var count = Std.parseInt(splitFighterLock[0]);
				for (i in 1...count + 1)
				{
					var fighter = splitFighterLock[i];
					if (!FlxStringUtil.isNullOrEmpty(fighter) && !characterLock.contains(fighter))
					{
						characterLock.push(fighter);
					}
				}
			}

			var count = Std.parseInt(splitFighters[0]);
			for (i in 1...count + 1)
			{
				var fighter = splitFighters[i];
				if (!FlxStringUtil.isNullOrEmpty(fighter))
				{
					var fighterData = Paths.crusadeData('data/dats/$fighter.dat');
					if (!FlxStringUtil.isNullOrEmpty(fighterData))
					{
						var splitFighterData = Util.getSplitText(fighterData);
						var character = new Character(fighter, splitFighterData[0], splitFighterData[1], splitFighterData[2], splitFighterData[3], nextID);
						characters.set(fighter, character);
						characterIDs.set(nextID, character);
						nextID++;
					}
				}
			}
		}
	}
}

class Character
{
	public var name:String = '';
	public var mugName:String = '';
	public var bustName:String = '';
	public var longName:String = '';
	public var series:String = '';
	public var id:Int = 0;
	public var forms:Array<CharacterForm> = [];

	public function new(name:String, mugName:String, bustName:String, longName:String, series:String, id:Int, ?forms:Array<CharacterForm>)
	{
		this.name = name;
		this.mugName = mugName;
		this.bustName = bustName;
		this.longName = longName;
		this.series = series;
		this.id = id;
		if (forms != null)
			this.forms = forms;
	}
}

class CharacterForm
{
	public var parentChar:String = '';
	public var name:String = '';
	public var bustName:String = '';
	public var longName:String = '';

	public function new(parentChar:String, name:String, bustName:String, longName:String)
	{
		this.parentChar = parentChar;
		this.name = name;
		this.bustName = bustName;
		this.longName = longName;
	}
}

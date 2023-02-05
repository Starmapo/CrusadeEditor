package states;

import data.CharacterData;
import data.MessageType;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxUIButton;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import haxe.io.Path;
import lime.app.Application;
import lime.system.System;
import sprites.CSS;
import sprites.CharacterSlot;
import sprites.ContextMenu;
import sys.FileSystem;
import sys.io.File;
import systools.Dialogs;

class CSSEditorState extends FlxState
{
	override public function create()
	{
		super.create();
		persistentDraw = false;

		_css = new CSS(0, 0, Paths.crusadeData('data/css.txt'));
		add(_css);

		var line1 = new FlxSprite(0, Util.CSS_Y).makeGraphic(FlxG.width, 2, FlxColor.WHITE);
		line1.scrollFactor.set();
		line1.active = false;
		add(line1);

		var line2 = new FlxSprite(0, line1.y + Util.CSS_HEIGHT).makeGraphic(FlxG.width, 2, FlxColor.WHITE);
		line2.scrollFactor.set();
		line2.active = false;
		add(line2);

		_slotSelect = new FlxSprite().makeGraphic(1, 1);
		_slotSelect.alpha = 0;
		_slotSelect.active = false;
		_slotSelect.scrollFactor.set();
		add(_slotSelect);

		var saveRosterButton = new FlxUIButton(5, Util.CSS_Y + Util.CSS_HEIGHT + 5, 'Save Roster', function()
		{
			if (_clickTimer <= 0)
			{
				var roster = _css.cssString();
				try
				{
					File.saveContent(Paths.crusadePath('data/css.txt'), roster);
					_showMessage("CSS saved successfully.", SUCCESS);
				}
				catch (e)
				{
					Application.current.window.alert('Couldn\'t save CSS: ${e.message}');
					_showMessage("Error: Couldn't save CSS.", ERROR);
				}
			}
		});
		add(saveRosterButton);

		var reloadRosterButton = new FlxUIButton(saveRosterButton.x + saveRosterButton.width + 5, saveRosterButton.y, 'Reload Roster', function()
		{
			if (_clickTimer <= 0)
			{
				_css.loadFromRoster(Paths.crusadeData('data/css.txt'));
				_onResizeCSS();
			}
		});
		add(reloadRosterButton);

		var addRowButton = new FlxUIButton(saveRosterButton.x, saveRosterButton.y + saveRosterButton.height + 5, 'Add Row', function()
		{
			if (_clickTimer <= 0)
			{
				_css.addRow();
				_onResizeCSS();
			}
		});
		add(addRowButton);

		var addColumnButton = new FlxUIButton(addRowButton.x + addRowButton.width + 5, addRowButton.y, 'Add Column', function()
		{
			if (_clickTimer <= 0)
			{
				_css.addColumn();
				_onResizeCSS();
			}
		});
		add(addColumnButton);

		var removeRowButton = new FlxUIButton(addColumnButton.x + addColumnButton.width + 5, addColumnButton.y, 'Remove Last Row', function()
		{
			if (_clickTimer <= 0 && _css.rows > 2)
			{
				_css.removeRow();
				_onResizeCSS();
			}
		});
		add(removeRowButton);

		var removeColumnButton = new FlxUIButton(removeRowButton.x + removeRowButton.width + 5, removeRowButton.y, 'Remove Last Column', function()
		{
			if (_clickTimer <= 0 && _css.columns > 1)
			{
				_css.removeColumn();
				_onResizeCSS();
			}
		});
		add(removeColumnButton);

		var changeDirectoryButton = new FlxUIButton(addRowButton.x, addRowButton.y + addRowButton.height + 5, 'Change Directory', function()
		{
			if (_clickTimer <= 0)
			{
				var result:String = Dialogs.folder("Select your game directory:", "");
				if (!FlxStringUtil.isNullOrEmpty(result) && FileSystem.exists(result))
				{
					Util.changeDirectory(result);
					FlxG.resetState();
				}
			}
		});
		add(changeDirectoryButton);

		var reloadCharactersButton = new FlxUIButton(changeDirectoryButton.x + changeDirectoryButton.width + 5, changeDirectoryButton.y, 'Reload Characters',
			function()
			{
				if (_clickTimer <= 0)
				{
					CharacterData.reloadCharacters();
					FlxG.resetState();
				}
			});
		add(reloadCharactersButton);

		var launchGameButton = new FlxUIButton(changeDirectoryButton.x, changeDirectoryButton.y + changeDirectoryButton.height + 5, 'Launch Game', function()
		{
			if (_clickTimer <= 0)
			{
				if (FlxG.save.data.gameExecutable == null || !FileSystem.exists(FlxG.save.data.gameExecutable))
				{
					var result = Dialogs.openFile('Select the game\'s executable file.', '', {
						count: 1,
						descriptions: ['EXE files'],
						extensions: ['*.exe']
					}, false)[0];
					if (result == null)
					{
						return;
					}
					FlxG.save.data.gameExecutable = result;
					FlxG.save.flush();
				}

				var directory = Path.directory(FlxG.save.data.gameExecutable);
				var cwd = Sys.getCwd();
				Sys.setCwd(directory);
				System.openFile(FlxG.save.data.gameExecutable);
				Sys.setCwd(cwd);
			}
		});
		add(launchGameButton);

		_infoText = new FlxText(0, 0, FlxG.width, '', 8);
		_infoText.active = false;
		_infoText.scrollFactor.set();
		add(_infoText);

		_charText = new FlxText(0, 0, FlxG.width, '', 8);
		_charText.active = false;
		_charText.scrollFactor.set();
		add(_charText);

		_onResizeCSS();

		_contextMenu = new ContextMenu();
		_contextMenu.visible = false;
		_contextMenu.callback = function(option)
		{
			switch (option)
			{
				case 'Replace':
					openSubState(new ChooseCharacterSubState(_css.getCharacters(), function(char)
					{
						if (char == null)
							_contextMenuSlot.char = 'random'; // stupid fix part 2
						else
							_contextMenuSlot.char = char.name;
						_contextMenuSlot = null;
						_updateInfoText();
					}));
				case 'Clear':
					_css.clearSlot(_contextMenuSlot.ID);
					_updateInfoText();
				case 'Remove':
					_css.removeSlot(_contextMenuSlot.ID);
			}
		};
		add(_contextMenu);

		_message = new FlxText(0, 0, FlxG.width, '', 32);
		_message.setFormat('_sans', 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		_message.borderSize = 2;
		_message.alpha = 0;
		_message.active = false;
		_message.scrollFactor.set();
		add(_message);

		Util.playMusic();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (_requestSubStateReset || subState != null)
			return;

		if (FlxG.mouse.justPressed || FlxG.mouse.justPressedRight)
		{
			_contextMenu.visible = false;
		}

		var overlap:Bool = false;
		FlxG.mouse.getWorldPosition(null, _point);
		_curSlot = null;
		for (i in 0..._css.length)
		{
			var slot = _css.members[i];
			if (slot != _selectedSlot && slot.overlapsPoint(_point, true))
			{
				if (!_contextMenu.visible)
				{
					_slotSelect.setPosition(slot.x, slot.y);
					_slotSelect.alpha = 0.5;
				}
				overlap = true;
				_curSlot = slot;
				if (FlxG.mouse.justPressed && _clickTimer <= 0)
				{
					if (!_contextMenu.visible)
					{
						_selectedSlot = slot;
						_startMousePos.copyFrom(_point);
						_startSlotPos.set(_curSlot.x, _curSlot.y);
						_isDragging = true;
					}
					_contextMenu.visible = false;
				}
				else if (FlxG.mouse.justPressedRight)
				{
					var options = ['Replace'];
					if (slot.char.length > 0)
					{
						options.push('Clear');
					}
					options.push('Remove');
					_contextMenu.changeOptions(options);
					_contextMenu.showAt(_point.x, _point.y);
					_contextMenuSlot = slot;
				}
				break;
			}
			if (overlap)
				break;
		}
		if (!overlap && !_contextMenu.visible)
		{
			_slotSelect.alpha = 0;
		}
		if (_curSlot != null && _curSlot.char.length > 0 && _curSlot.char != 'random')
		{
			if (_lastCharText != _curSlot.char)
			{
				_updateCharText(CharacterData.characters.get(_curSlot.char));
			}
		}
		else
		{
			_charText.text = '';
			_lastCharText = '';
		}

		if (FlxG.mouse.justReleased && _isDragging)
		{
			_isDragging = false;
			if (_curSlot != null)
			{
				if (FlxG.keys.pressed.SHIFT)
				{
					_css.swapIcons(_selectedSlot.ID, _curSlot.ID);
				}
				else
				{
					_css.moveIcon(_selectedSlot.ID, _curSlot.ID);
				}
			}
			_selectedSlot.setPosition(_startSlotPos.x, _startSlotPos.y);
			_selectedSlot = null;
		}
		else if (FlxG.mouse.justMoved && _isDragging)
		{
			FlxG.mouse.getWorldPosition(null, _point);
			_selectedSlot.setPosition((_point.x - _startMousePos.x) + _startSlotPos.x, (_point.y - _startMousePos.y) + _startSlotPos.y);
		}

		if (_clickTimer > 0)
		{
			_clickTimer--;
		}

		if (FlxG.keys.justPressed.F1)
		{
			FlxG.save.data.gameExecutable = null;
			FlxG.save.flush();
		}
	}

	override function closeSubState()
	{
		_clickTimer = 5;
		super.closeSubState();
	}

	var _css:CSS;
	var _slotSelect:FlxSprite;
	var _point:FlxPoint = FlxPoint.get();
	var _startMousePos:FlxPoint = FlxPoint.get();
	var _startSlotPos:FlxPoint = FlxPoint.get();
	var _selectedSlot:CharacterSlot;
	var _curSlot:CharacterSlot;
	var _message:FlxText;
	var _contextMenu:ContextMenu;
	var _infoText:FlxText;
	var _charText:FlxText;
	var _contextMenuSlot:CharacterSlot;
	var _lastCharText:String;
	var _clickTimer:Int = 0;
	var _isDragging:Bool = false;

	function _showMessage(text:String, type:MessageType = NORMAL)
	{
		var color:FlxColor;
		switch (type)
		{
			case SUCCESS:
				color = FlxColor.LIME;
			case ERROR:
				color = FlxColor.RED;
			default:
				color = FlxColor.WHITE;
		}

		_message.text = text;
		_message.color = color;
		_message.alpha = 1;
		FlxTween.cancelTweensOf(_message);
		FlxTween.tween(_message, {alpha: 0}, 1, {startDelay: 2});
	}

	function _centerCSS()
	{
		Util.centerInBounds(_css, 0, Util.CSS_Y, FlxG.width, Util.CSS_HEIGHT);
	}

	function _onResizeCSS()
	{
		_centerCSS();
		_slotSelect.setGraphicSize(Std.int(Util.slotWidth * _css.cssScale), Std.int(Util.slotHeight * _css.cssScale));
		_slotSelect.updateHitbox();
		_updateInfoText();
	}

	function _updateInfoText()
	{
		var characters = _css.getCharacters();
		_infoText.text = 'Slot Count: ${_css.length} | Rows: ${_css.rows} | Columns: ${_css.columns} | Character Count: ${characters.length}';
		_infoText.y = FlxG.height - _infoText.height;
		_charText.y = _infoText.y - _charText.height;
	}

	function _updateCharText(char:Character)
	{
		if (char != null)
		{
			_charText.text = 'Character: ${char.name} | CSS Name: ${char.mugName} | Menu Name: ${char.bustName} | Battle Name: ${char.longName} | Universe: ${char.series}';
			_lastCharText = char.name;
		}
	}
}

ScriptName ZombificationMCMQuestScript extends SKI_ConfigBase

PlayerZombieQuestScript Property PlayerZombieQuest Auto
Perk Property ZombieFeedingPerk Auto

bool checkboxState
int _zombifyPlayerControlId
int _curePlayerControlId
int _zombieFeedBonusControlId
int _zombieFeedBonusTypeId
int _stageTimeControlId
int _hateControlId
int[] _controlIds
int _timesFedId

string _homePageName
string _stage1PageName
string _stage2PageName
string _stage3PageName

Event OnConfigInit()
	_homePageName = "Home"
	_stage1PageName = "Stage 1 Settings"
	_stage2PageName = "Stage 2 Settings"
	_stage3PageName = "Stage 3 Settings"
	Self.Pages = new string[4]
	Self.Pages[0] = _homePageName
	Self.Pages[1] = _stage1PageName
	Self.Pages[2] = _stage2PageName
	Self.Pages[3] = _stage3PageName
EndEvent

Event OnOptionSelect(int option)
	If (option == _zombifyPlayerControlId)
		SetOptionFlags(option, OPTION_FLAG_DISABLED)
		Self.PlayerZombieQuest.zombifyPlayer()
		Game.getPlayer().AddPerk(Self.ZombieFeedingPerk)
		SetToggleOptionValue(option, true)
	ElseIf (option == _curePlayerControlId)
		SetOptionFlags(option, OPTION_FLAG_DISABLED)
		Self.PlayerZombieQuest.curePlayer()
		Game.getPlayer().RemovePerk(Self.ZombieFeedingPerk)
		SetToggleOptionValue(option, true)
	ElseIf (option == _hateControlId)
		Self.PlayerZombieQuest.ZombieHatred = !Self.PlayerZombieQuest.ZombieHatred
		SetToggleOptionValue(option, Self.PlayerZombieQuest.ZombieHatred)
	EndIf
	
	
EndEvent

Float Function GetOptionCurrentValue(int index) 
	if (Self.CurrentPage == _stage1PageName)
		return Self.PlayerZombieQuest.ZombieStage1Stats[index]
	ElseIf (Self.CurrentPage == _stage2PageName)
		return Self.PlayerZombieQuest.ZombieStage2Stats[index]
	ElseIf (Self.CurrentPage == _stage3PageName)
		return Self.PlayerZombieQuest.ZombieStage3Stats[index]
	EndIf
EndFunction

Function SetOptionValue(Int index, Float Value)
	if (Self.CurrentPage == _stage1PageName)
		Self.PlayerZombieQuest.ZombieStage1Stats[index] = Value
	ElseIf (Self.CurrentPage == _stage2PageName)
		Self.PlayerZombieQuest.ZombieStage2Stats[index] = Value
	ElseIf (Self.CurrentPage == _stage3PageName)
		Self.PlayerZombieQuest.ZombieStage3Stats[index] = Value
	EndIf
EndFunction

Int Function GetStatOptionIndex(int option)
	int i = 0
	while (i < _controlIds.length) 
		if (_controlIds[i] == option)
			return i
		EndIf
		i += 1
	EndWhile
	
	return -1
EndFunction

Event OnOptionSliderOpen(int option)
	If (option == _stageTimeControlId)
		SetSliderDialogStartValue((PlayerZombieQuest.ZombieDaysBetweenStages * 24) as Int)
		SetSliderDialogDefaultValue(24)
		SetSliderDialogRange(3, 72)
		SetSliderDialogInterval(3)
	ElseIf (option == _zombieFeedBonusControlId)
		SetSliderDialogStartValue(PlayerZombieQuest.ZombieFeedBonus * 100)
		SetSliderDialogDefaultValue(0.02)
		SetSliderDialogRange(0, 1.0)
		SetSliderDialogInterval(0.005)
	Else
		Int controlIndex = Self.GetStatOptionIndex(option)
		If (controlIndex != -1)
			SetSliderDialogStartValue(Self.GetOptionCurrentValue(controlIndex))
			SetSliderDialogDefaultValue(0)
			if (controlIndex < 3)
				SetSliderDialogRange(-100, 300)
				SetSliderDialogInterval(5)
			ElseIf (controlIndex < 22)
				SetSliderDialogRange(-200, 200)
				SetSliderDialogInterval(5)			
			ElseIf (controlIndex < 28) ;Magic resistances
				SetSliderDialogRange(-100, 100)
				SetSliderDialogInterval(1)
			ElseIf (controlIndex == 28) ;Unarmed Damage
				SetSliderDialogRange(0, 50)
				SetSliderDialogInterval(1)
			ElseIf (controlIndex == 29) ;Attack damage multiplier
				SetSliderDialogRange(-1, 2)
				SetSliderDialogInterval(0.1)
			ElseIf (controlIndex == 30) ;Move speed multiplier
				SetSliderDialogRange(-100, 100)
				SetSliderDialogInterval(5)
			EndIf
		EndIf
	EndIf
EndEvent

Event OnOptionSliderAccept(int option, float value)
	If (option == _stageTimeControlId)
		Self.PlayerZombieQuest.ZombieDaysBetweenStages = value / 24.0
		SetSliderOptionValue(option, Value, "{0} Hours")
	ElseIf (option == _zombieFeedBonusControlId)
		Self.PlayerZombieQuest.ZombieFeedBonus = (value / 100.0)
		SetSliderOptionValue(option, value, "{3}%")
	Else		
		int index = Self.GetStatOptionIndex(option)
		Self.SetOptionValue(index, value)
		If (index == 29)
			SetSliderOptionValue(option, Value, "{1}")
		Else
			SetSliderOptionValue(option, Value)
		EndIf
	EndIf
	
	
EndEvent

Event OnOptionMenuOpen(int option)
	SetMenuDialogOptions(self.getStatGrowthModes())
	SetMenuDialogDefaultIndex(0)
	SetMenuDialogStartIndex(Self.PlayerZombieQuest.StatGrowthMode)
EndEvent

Event OnOptionMenuAccept(int option, int index)
	Self.PlayerZombieQuest.StatGrowthMode = index
	SetMenuOptionValue(option, self.getStatGrowthModes()[index])
EndEvent

Int Function getPageStage() 
	if (Self.CurrentPage == _stage1PageName)
		return 1
	ElseIf (Self.CurrentPage == _stage2PageName)
		return 2
	ElseIf (Self.CurrentPage == _stage3PageName)
		return 3
	EndIf
	
	return -1
EndFunction

event OnOptionHighlight(int option)
	if(option == _zombifyPlayerControlId)
		SetInfoText("Become a zombie");
	ElseIf (option == _curePlayerControlId)
		SetInfoText("Cure yourself and become human again")
	ElseIf (option == _stageTimeControlId)
		SetInfoText("Time it takes since your last feeding to advance to the next stage of zombie decay")
	ElseIf (option == _zombieFeedBonusControlId)
		SetInfoText("The degree to which buffs and debuffs will be increased for each time you have fed")
	ElseIf (option == _hateControlId)
		SetInfoText("If you should be attacked by everybody when you are a stage 3 zombie")
	ElseIf (option == _timesFedId)
		SetInfoText("Number of times you have tasted the flesh of the living")
	ElseIf (option == _zombieFeedBonusTypeId)
		SetInfoText("The way the Zombie Growth is applied.\nAmplify: Buffs are improved but debuffs are more severe.\nImprove: Buffs are improved while debuffs are slowly eliminated.\nDebuffs Unchanged: Buffs are improved while debuffs are left unchanged.\nNo Growth: Feeding does not effect buffs and debuffs.")
	Else
		int index = Self.GetStatOptionIndex(option);
		if(index != -1)
			SetInfoText("How much your " + Self.getAVLabels()[index] + " stat will be modified while you are a stage " + (Self.getPageStage()) + " Zombie.");
		EndIf
	EndIf
EndEvent

String[] Function getAVLabels()
	string[] AVs = new string[31]
	AVs[0] = "Health"
	AVs[1] = "Magicka"
	AVs[2] = "Stamina"
	AVs[3] = "One Handed"
	AVs[4] = "Two Handed"
	AVs[5] = "Marksman"
	AVs[6] = "Block"
	AVs[7] = "Smithing"
	AVs[8] = "Heavy Armor"
	AVs[9] = "Light Armor"
	AVs[10] = "Pickpocket"
	AVs[11] = "Lockpicking"
	AVs[12] = "Sneak"
	AVs[13] = "Alchemy"
	AVs[14] = "Speechcraft"
	AVs[15] = "Alteration"
	AVs[16] = "Conjuration"
	AVs[17] = "Destruction"
	AVs[18] = "Illusion"
	AVs[19] = "Restoration"
	AVs[20] = "Enchanting"
	AVs[21] = "Armor Bonus"
	AVs[22] = "Disease Resistance"
	AVs[23] = "Poison Resistance"
	AVs[24] = "Magic Resistance"
	AVs[25] = "Fire Resistance"
	AVs[26] = "Frost Resistance"
	AVs[27] = "Electric Resistance"
	AVs[28] = "Unarmed Damage"
	AVs[29] = "Attack Damage Multiplier"
	AVs[30] = "Move Speed Multiplier"
	return AVs
EndFunction

String[] Function getStatGrowthModes()
	string[] modes = new String[4]
	modes[0] = "Amplify"
	modes[1] = "Improve"
	modes[2] = "Debuffs Unchanged"
	modes[3] = "No Growth"
	return modes
EndFunction

event OnPageReset(string page)
	_zombifyPlayerControlId = -1
	_curePlayerControlId = -1
	_zombieFeedBonusControlId = -1
	_zombieFeedBonusTypeId = -1
	_stageTimeControlId = -1
	_timesFedId = -1
	_controlIds = new int[31]

	SetCursorPosition(0)
	SetCursorFillMode(TOP_TO_BOTTOM)
	
	if (page == "" || page == _homePageName)
		AddHeaderOption("Main Zombie Controls");
		If (!PlayerZombieQuest.isPlayerZombie())
			_zombifyPlayerControlId = AddToggleOption("Become a Zombie", false)
		Else
			_curePlayerControlId = AddToggleOption("Cure yourself", false)
		EndIf
		
		AddEmptyOption()
		_stageTimeControlId = AddSliderOption("Zombie Stage Timer", (Self.PlayerZombieQuest.ZombieDaysBetweenStages * 24) as Int, "{0} Hours")
		_zombieFeedBonusControlId = AddSliderOption("Zombie Growth", Self.PlayerZombieQuest.ZombieFeedBonus * 100, "{3}%")
		_zombieFeedBonusTypeId = AddMenuOption("Growth Type", Self.getStatGrowthModes()[Self.PlayerZombieQuest.StatGrowthMode])
		_hateControlId = AddToggleOption("Stage 3 hatred", Self.PlayerZombieQuest.ZombieHatred)
		
		SetCursorPosition(1)
		_timesFedId = AddTextOption("Times Fed", Self.PlayerZombieQuest.TimesFed as string)
	else
		float[] values
		if (page == _stage1PageName)
			values = PlayerZombieQuest.ZombieStage1Stats
		ElseIf (page == _stage2PageName)
			values = PlayerZombieQuest.ZombieStage2Stats
		ElseIf (page == _stage3PageName)
			values = PlayerZombieQuest.ZombieStage3Stats
		EndIf
		
		string[] AVs = getAVLabels()
		
		AddHeaderOption("Attribute Modifiers")
		_controlIds[0] = AddSliderOption(AVs[0], values[0])
		_controlIds[1] = AddSliderOption(AVs[1], values[1])
		_controlIds[2] = AddSliderOption(AVs[2], values[2])
		AddHeaderOption("Skill Modfiers")
		int i = 3
		While (i < 21)
			_controlIds[i] = AddSliderOption(AVs[i], values[i])
			i += 1
		EndWhile
		AddHeaderOption("Other Modifiers")
		While (i < 29)
			_controlIds[i] = AddSliderOption(AVs[i], values[i])
			i += 1
		EndWhile
		_controlIds[29] = AddSliderOption(AVs[29], values[29], "{1}")
		_controlIds[30] = AddSliderOption(AVs[30], values[30])
		
	EndIf
endEvent
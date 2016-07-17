ScriptName ZombificationMCMQuestScript extends SKI_ConfigBase

PlayerZombieQuestScript Property PlayerZombieQuest Auto
Perk Property ZombieFeedingPerk Auto

bool checkboxState
int _zombifyPlayerControlId
int _curePlayerControlId
int _stageTimeControlId
int[] _controlIds

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
		Self.PlayerZombieQuest.zombifyPlayer()
		Game.getPlayer().AddPerk(Self.ZombieFeedingPerk)
	ElseIf (option == _curePlayerControlId)
		Self.PlayerZombieQuest.curePlayer()
		Game.getPlayer().RemovePerk(Self.ZombieFeedingPerk)
	EndIf
	
	SetToggleOptionValue(option, true)
EndEvent

Int Function GetOptionCurrentValue(int index) 
	if (Self.CurrentPage == _stage1PageName)
		return Self.PlayerZombieQuest.ZombieStage1Stats[index]
	ElseIf (Self.CurrentPage == _stage2PageName)
		return Self.PlayerZombieQuest.ZombieStage2Stats[index]
	ElseIf (Self.CurrentPage == _stage3PageName)
		return Self.PlayerZombieQuest.ZombieStage3Stats[index]
	EndIf
EndFunction

Function SetOptionValue(Int index, Int Value)
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
			return _controlIds[i]
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
	Else
		Int controlIndex = Self.GetStatOptionIndex(option)
		If (controlIndex != -1)
			SetSliderDialogStartValue(Self.GetOptionCurrentValue(controlIndex))
			SetSliderDialogDefaultValue(0)
			SetSliderDialogRange(-100, 100)
			SetSliderDialogInterval(1)
		EndIf
	EndIf
EndEvent

Event OnOptionSliderAccept(int option, float value)
	If (option == _stageTimeControlId)
		Self.PlayerZombieQuest.ZombieDaysBetweenStages = value / 24.0
	Else
		Self.SetOptionValue(Self.GetStatOptionIndex(option), value as Int)
	EndIf
	
	SetSliderOptionValue(option, Value as Int)
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
	Else
		int index = findOptionIndex(option);
		if(index != -1)
			SetInfoText("How much you " + Self.PlayerZombieQuest.getAVs()[index] + " will be modified while you are a stage " + (Self.getPageStage() + 1) + " Zombie.");
		EndIf
	EndIf
EndEvent

int Function findOptionIndex(int optionId)
	int i = 0;
	while(i < _controlIds.length)
		if(_controlIds[i] == optionId)
			return i;
		EndIf
		i += 1;
	EndWhile
	
	return -1;
EndFunction

event OnPageReset(string page)
	_zombifyPlayerControlId = -1
	_curePlayerControlId = -1
	_stageTimeControlId = -1
	_controlIds = new int[21]

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
		_stageTimeControlId = AddSliderOption("Zombie Stage Timer", (Self.PlayerZombieQuest.ZombieDaysBetweenStages * 24) as Int)
	else
		int[] values
		if (page == _stage1PageName)
			values = PlayerZombieQuest.ZombieStage1Stats
			AddHeaderOption("Zombie Stage 1 Settings")
		ElseIf (page == _stage2PageName)
			values = PlayerZombieQuest.ZombieStage2Stats
			AddHeaderOption("Zombie Stage 2 Settings")
		ElseIf (page == _stage3PageName)
			values = PlayerZombieQuest.ZombieStage3Stats
			AddHeaderOption("Zombie Stage 3 Settings")
		EndIf
		
		string[] AVs = PlayerZombieQuest.getAVs()
		
		AddHeaderOption("Attribute Modifiers")
		_controlIds[0] = AddSliderOption(AVs[0], values[0])
		_controlIds[1] = AddSliderOption(AVs[1], values[1])
		_controlIds[2] = AddSliderOption(AVs[2], values[2])
		AddHeaderOption("Skill Modfiers")
		int i = 3
		While (i < AVs.length)
			_controlIds[i] = AddSliderOption(AVs[i], PlayerZombieQuest.ZombieStage1Stats[i])
			i += 1
		EndWhile
	EndIf
endEvent
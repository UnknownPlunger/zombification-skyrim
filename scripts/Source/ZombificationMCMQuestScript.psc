ScriptName ZombificationMCMQuestScript extends SKI_ConfigBase

PlayerZombieQuestScript Property PlayerZombieQuest Auto

bool checkboxState
int _zombifyPlayerControlId
int _curePlayerControlId
int _stageTimeControlId
int[] _controlIds

Event OnConfigInit()
	Self.Pages = new string[3]
	Self.Pages[0] = "Stage 1 Settings"
	Self.Pages[1] = "Stage 2 Settings"
	Self.Pages[2] = "Stage 3 Settings"
EndEvent

Int Function getPageNumber() 
	int i = 0
	while (i < Self.Pages.length)
		If (Self.Pages[i] == Self.CurrentPage)
			return i
		EndIf
		i += 1
	EndWhile
	
	return -1
EndFunction

Event OnOptionSelect(int option)
	If (option == _zombifyPlayerControlId)
		Self.PlayerZombieQuest.zombifyPlayer()
	ElseIf (option == _curePlayerControlId)
		Self.PlayerZombieQuest.curePlayer()
	EndIf
	
	SetToggleOptionValue(option, true)
EndEvent

Int Function GetOptionCurrentValue(int index) 
	if (Self.getPageNumber() == 0)
		return Self.PlayerZombieQuest.ZombieStage1Stats[index]
	ElseIf (Self.getPageNumber() == 1)
		return Self.PlayerZombieQuest.ZombieStage2Stats[index]
	ElseIf (Self.getPageNumber() == 2)
		return Self.PlayerZombieQuest.ZombieStage3Stats[index]
	EndIf
EndFunction

Function SetOptionValue(Int index, Int Value)
	if (Self.getPageNumber() == 0)
		Self.PlayerZombieQuest.ZombieStage1Stats[index] = Value
	ElseIf (Self.getPageNumber() == 1)
		Self.PlayerZombieQuest.ZombieStage2Stats[index] = Value
	ElseIf (Self.getPageNumber() == 2)
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
			SetInfoText("How much you " + Self.PlayerZombieQuest.getAVs()[index] + " will be modified while you are a stage " + (Self.getPageNumber() + 1) + " Zombie.");
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
	_controlIds = new int[21]

	SetCursorFillMode(TOP_TO_BOTTOM);
	SetCursorPosition(1)
	
	if (page == "")
		AddHeaderOption("Main Zombie Controls");
		If (PlayerZombieQuest.isPlayerZombie())
			_zombifyPlayerControlId = AddToggleOption("Become a Zombie", false)
		Else
			_curePlayerControlId = AddToggleOption("Cure yourself", false)
		EndIf
		
		AddEmptyOption()
		_stageTimeControlId = AddSliderOption("Zombie Stage Timer", (Self.PlayerZombieQuest.ZombieDaysBetweenStages * 24) as Int)
	else
		int[] values
		if (page == Self.Pages[0])
			values = PlayerZombieQuest.ZombieStage1Stats
			AddHeaderOption("Zombie Stage 1 Settings")
		ElseIf (page == Self.Pages[1])
			values = PlayerZombieQuest.ZombieStage2Stats
			AddHeaderOption("Zombie Stage 2 Settings")
		ElseIf (page == Self.Pages[2])
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
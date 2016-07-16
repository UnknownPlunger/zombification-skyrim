ScriptName ZombificationMCMQuestScript extends SKI_ConfigBase

PlayerZombieQuestScript Property PlayerZombieQuest Auto

bool checkboxState
int _zombifyPlayerControlId
int _curePlayerControlId
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
		Self.checkboxState = true
		Self.PlayerZombieQuest.zombifyPlayer()
	ElseIf (option == _curePlayerControlId)
		Self.checkboxState = true
		Self.PlayerZombieQuest.curePlayer()
	EndIf
EndEvent

Event OnOptionSliderOpen(int option)

EndEvent

Event OnOptionSliderAccept(int option, float value)

EndEvent

event OnOptionHighlight(int option)
	if(option == _zombifyPlayerControlId)
		SetInfoText("Become a zombie");
	ElseIf (option == _curePlayerControlId)
		SetInfoText("Cure yourself and become human again")
	Else
		int index = findOptionIndex(option);
		if(index != -1)
			SetInfoText("How much you " + Self.PlayerZombieQuest.getAVs[index] + " will be modified while you are a stage " + (Self.getPageNumber() + 1) + " Zombie.");
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
	_zombifyPlayerControlId = NONE
	_curePlayerControlId = NONE
	_controlIds = new int[21]

	SetCursorFillMode(TOP_TO_BOTTOM);
	SetCursorPosition(1)
	
	if (page == "")
		AddHeaderOption("Main Zombie Controls");
		Self.checkboxState = false
		If (PlayerZombieQuest.isPlayerZombie())
			_zombifyPlayerControlId = AddToggleOption("Become a Zombie", checkboxState)
		Else
			_curePlayerControlId = AddToggleOption("Cure yourself", checkboxState)
		EndIf
	else
		GlobalVariable[] values
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
		_controlIds[0] = AddSliderOption(AVs[0], values[0].getValueInt())
		_controlIds[1] = AddSliderOption(AVs[1], values[1].getValueInt())
		_controlIds[2] = AddSliderOption(AVs[2], values[2].getValueInt())
		AddHeaderOption("Skill Modfiers")
		int i = 3
		While (i < AVs.length)
			_controlIds[i] = AddSliderOption(AVs[i], PlayerZombieQuest.ZombieStage1Stats[i].getValueInt())
			i += 1
		EndWhile
	EndIf
endEvent
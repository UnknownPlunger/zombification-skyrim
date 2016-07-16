ScriptName PlayerZombieQuestScript extends Quest

Bool Property PlayerIsZombie Auto

Message Property ZombieFeedMessageStage1 Auto
Message Property ZombieFeedMessageStage3 Auto
Message Property ZombieStage1Message Auto
Message Property ZombieStage2Message Auto
Message Property ZombieStage3Message Auto

Int Property ZombieStage Auto
GlobalVariable Property GameDaysPassed Auto
GlobalVariable Property ZombieDaysBetweenStages Auto
Float Property ZombieStageTime Auto

GlobalVariable Property ZombieHatred Auto
GlobalVariable[] Property ZombieStage1Stats Auto
GlobalVariable[] Property ZombieStage2Stats Auto
GlobalVariable[] Property ZombieStage3Stats Auto

Int[] Property LastChangeStats Auto

String[] Function getAVs()
	string[] AVs = new string[21]
	AVs[0] = "health"
	AVs[1] = "magicka"
	AVs[2] = "stamina"
	AVs[3] = "oneHanded"
	AVs[4] = "twoHanded"
	AVs[5] = "marksman"
	AVs[6] = "block"
	AVs[7] = "smithing"
	AVs[8] = "heavyArmor"
	AVs[9] = "lightArmor"
	AVs[10] = "pickpocket"
	AVs[11] = "lockpicking"
	AVs[12] = "sneak"
	AVs[13] = "alchemy"
	AVs[14] = "speechcraft"
	AVs[15] = "alteration"
	AVs[16] = "conjuration"
	AVs[17] = "destruction"
	AVs[18] = "illusion"
	AVs[19] = "restoration"
	AVs[20] = "enchanting"
EndFunction

Function setStageStats(Int stage)
	GlobalVariable[] stageValues
	If (stage == 1)
		stageValues = Self.ZombieStage1Stats
	ElseIf (stage == 2)
		stageValues = Self.ZombieStage2Stats
	Else
		stageValues = Self.ZombieStage3Stats
	EndIf
	int i = stageValues.length
	string[] AVs = Self.getAVs()
	While (i < stageValues.length)
		Game.getPlayer().modActorValue(AVs[i], stageValues[i].getValueInt())
		i += 1
	EndWhile
	
	Self.backupChangeValues(stageValues)
EndFunction

Function backupChangeValues(GlobalVariable[] stageValues)
	Self.LastChangeStats = new Int[21]
	int i = 0
	While (i < LastChangeStats.length)
		LastChangeStats[i] = stageValues[i].getValueInt()
		i += 1
	EndWhile
EndFunction

Function clearStageStats()
	If (lastChangeStats != None)
		int i = Self.LastChangeStats.length
		string[] AVs = Self.getAVs()
		While (i < Self.LastChangeStats.length)
			Game.getPlayer().modActorValue(AVs[i], 0 - lastChangeStats[i])
			i += 1
		EndWhile
		
		lastChangeStats = None
	EndIf
EndFunction

Event OnUpdateGameTime()
	If  (Game.IsMovementControlsEnabled() && Game.IsFightingControlsEnabled() && Game.GetPlayer().GetCombatState() == 0)
		float stageElapsedTime = GameDaysPassed.Value - Self.ZombieStageTime
				
		If (stageElapsedTime >= Self.ZombieDaysBetweenStages.getValue())
			;AdvanceStage
			Self.ZombieStageTime += Self.ZombieDaysBetweenStages.getValue()
		
			If (Self.ZombieStage == 1)
				Self.ZombieStage = 2
				Self.clearStageStats()
				Self.setStageStats(2)
				Self.ZombieStage2Message.show()
			Elseif (Self.Zombiestage == 2)
				Self.ZombieStage = 3
				Self.clearStageStats()
				Self.setStageStats(3)
				Self.ZombieStage3Message.show()
				If (Self.ZombieHatred.getValueInt() == 1)
					Game.getPlayer().SetAttackActorOnSight()
				EndIf
				Self.UnregisterForUpdateGameTime()
			EndIf
		EndIf
	EndIf
EndEvent

Function feed()
	Self.ZombieStageTime = Self.GameDaysPassed.getValue()
	If (Self.ZombieStage == 1)
		Self.ZombieFeedMessageStage1.show()
	Elseif (Self.Zombiestage == 2)
		Self.ZombieStage = 1
		Self.clearStageStats()
		Self.setStageStats(1)
		Self.ZombieFeedMessageStage1.show()
		Self.ZombieStage1Message.show()
	ElseIf (Self.ZombieStage == 3)
		Self.ZombieStage = 2
		Self.clearStageStats()
		Self.setStageStats(2)
		Self.ZombieFeedMessageStage3.show()
		Self.ZombieStage2Message.show()
		Game.getPlayer().SetAttackActorOnSight(false)

		Self.UnregisterForUpdateGameTime()
		Self.RegisterForUpdateGameTime(3)
	EndIf
EndFunction

Function zombifyPlayer() 
	If (!PlayerIsZombie)
		Self.PlayerIsZombie = true
		Self.ZombieStage = 1
		Self.ZombieStageTime = Self.GameDaysPassed.getValue()
		Self.setStageStats(1)
		Self.RegisterForUpdateGameTime(3)
	EndIf
EndFunction

Function curePlayer()
	If(PlayerIsZombie)
		Self.ClearStageStats()
		Self.UnregisterForUpdateGameTime()
	EndIf
EndFunction

Bool Function isPlayerZombie()
	return Self.PlayerIsZombie;
EndFunction
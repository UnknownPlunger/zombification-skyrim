ScriptName PlayerZombieQuestScript extends Quest Conditional

Bool Property PlayerIsZombie Auto

Message Property ZombieRisen Auto
Message Property ZombieCured Auto
Message Property ZombieFeedMessageStage1 Auto
Message Property ZombieFeedMessageStage3 Auto
Message Property ZombieStage1Message Auto
Message Property ZombieStage2Message Auto
Message Property ZombieStage3Message Auto

Spell Property ZombieStage1Ability Auto
Spell Property ZombieStage2Ability Auto
Spell Property ZombieStage3Ability Auto

Int Property ZombieStage Auto
GlobalVariable Property GameDaysPassed Auto
Float Property ZombieDaysBetweenStages Auto
Float Property ZombieStageTime Auto

Bool Property ZombieHatred Auto
Int[] Property ZombieStage1Stats Auto
Int[] Property ZombieStage2Stats Auto
Int[] Property ZombieStage3Stats Auto

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
	
	return AVs
EndFunction

Function setStageStats(Int stage)
	Int[] stageValues
	If (stage == 1)
		stageValues = Self.ZombieStage1Stats
	ElseIf (stage == 2)
		stageValues = Self.ZombieStage2Stats
	Else
		stageValues = Self.ZombieStage3Stats
	EndIf
	int i = 0
	string[] AVs = Self.getAVs()
	While (i < stageValues.length)
		Game.getPlayer().modActorValue(AVs[i], stageValues[i])
		i += 1
	EndWhile
	
	Self.backupChangeValues(stageValues)
EndFunction

Function backupChangeValues(Int[] stageValues)
	Self.LastChangeStats = new Int[21]
	int i = 0
	While (i < LastChangeStats.length)
		LastChangeStats[i] = stageValues[i]
		i += 1
	EndWhile
EndFunction

Function clearStageStats()
	If (lastChangeStats != None)
		int i = 0
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
				
		If (stageElapsedTime >= Self.ZombieDaysBetweenStages)
			;AdvanceStage
			If (Self.ZombieStage == 1 && stageElapsedTime < 2)
				Self.ZombieStage = 2
				Self.clearStageStats()
				Self.setStageStats(2)
				game.GetPlayer().RemoveSpell(Self.ZombieStage1Ability)
				game.GetPlayer().AddSpell(Self.ZombieStage2Ability)
				game.GetPlayer().RemoveSpell(Self.ZombieStage3Ability)
				Self.ZombieStage2Message.show()
			Elseif (Self.Zombiestage == 2 || stageElapsedTime >= 2)
				Self.ZombieStage = 3
				Self.clearStageStats()
				Self.setStageStats(3)
				game.GetPlayer().RemoveSpell(Self.ZombieStage1Ability)
				game.GetPlayer().RemoveSpell(Self.ZombieStage2Ability)
				game.GetPlayer().AddSpell(Self.ZombieStage3Ability)
				Self.ZombieStage3Message.show()
				If (Self.ZombieHatred)
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
		game.GetPlayer().AddSpell(Self.ZombieStage1Ability)
		game.GetPlayer().RemoveSpell(Self.ZombieStage2Ability)
		game.GetPlayer().RemoveSpell(Self.ZombieStage3Ability)
		Self.ZombieFeedMessageStage1.show()
		Self.ZombieStage1Message.show()
	ElseIf (Self.ZombieStage == 3)
		Self.ZombieStage = 2
		Self.clearStageStats()
		Self.setStageStats(2)
		game.GetPlayer().RemoveSpell(Self.ZombieStage1Ability)
		game.GetPlayer().AddSpell(Self.ZombieStage2Ability)
		game.GetPlayer().RemoveSpell(Self.ZombieStage3Ability)
		Game.getPlayer().SetAttackActorOnSight(false)
		Self.UnregisterForUpdateGameTime()
		Self.RegisterForUpdateGameTime(3)
		
		Self.ZombieFeedMessageStage3.show()
		Self.ZombieStage2Message.show()
	EndIf
EndFunction

Function zombifyPlayer() 
	If (!PlayerIsZombie)
		Self.PlayerIsZombie = true
		Self.ZombieStage = 1
		Self.ZombieStageTime = Self.GameDaysPassed.getValue()
		Self.setStageStats(1)
		Self.RegisterForUpdateGameTime(3)
		Self.ZombieRisen.Show()
	EndIf
EndFunction

Function curePlayer()
	If(PlayerIsZombie)
		Self.ClearStageStats()
		Game.getPlayer().SetAttackActorOnSight(false)
		Self.UnregisterForUpdateGameTime()
		Self.ZombieCured.show()
	EndIf
EndFunction

Bool Function isPlayerZombie()
	return Self.PlayerIsZombie;
EndFunction
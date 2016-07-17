ScriptName DA11RingofNamiraScript extends ObjectReference

Perk Property DA11Cannibalism  Auto

Spell Property ZombieRingofNamiraSpell Auto

PlayerZombieQuestScript Property PlayerZombieQuest Auto

Event OnEquipped(Actor akActor)

	If (akActor == Game.GetPlayer() && !PlayerZombieQuest.PlayerIsZombie) 
		Game.GetPlayer().AddPerk(DA11Cannibalism )
	ElseIf (akActor == Game.GetPlayer())
		Game.GetPlayer().AddSpell(Self.ZombieRingofNamiraSpell)
	EndIf

EndEvent

Event OnUnequipped(Actor akActor)

	If akActor == Game.GetPlayer()
		Game.GetPlayer().RemovePerk(DA11Cannibalism )
		Game.GetPlayer().RemoveSpell(Self.ZombieRingofNamiraSpell)
	EndIf

EndEvent


;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 26
Scriptname PRKF_ZombieFeedingPerk_020022EC Extends Perk Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
Self.ZombieIsProcessing.SetValueInt(1)
Game.GetPlayer().StartCannibal(akTargetRef as Actor)
PlayerZombieQuest.feed();
Self.ZombieIsProcessing.SetValueInt(0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

PlayerZombieQuestScript Property PlayerZombieQuest  Auto  
GlobalVariable Property ZombieIsProcessing Auto

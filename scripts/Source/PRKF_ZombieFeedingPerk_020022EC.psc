;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 5
Scriptname PRKF_ZombieFeedingPerk_020022EC Extends Perk Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
Game.GetPlayer().StartCannibal(akTargetRef as Actor)
PlayerZombieQuest.feed();
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

PlayerZombieQuestScript Property PlayerZombieQuest  Auto  
;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 17
Scriptname PRKF_ZombieFeedingPerk_020022EC Extends Perk Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
Game.GetPlayer().StartCannibal(akTargetRef as Actor)
PlayerZombieQuest.feed();
_akTargetRef = akTargetref
RegisterForSingleUpdate(3)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

PlayerZombieQuestScript Property PlayerZombieQuest  Auto  

ActorBase Property TreasCorpseSkeleton Auto

ObjectReference _akTargetRef

Event OnUpdate()
	ObjectReference skele = (_akTargetRef.PlaceAtMe(self.TreasCorpseSkeleton, 1))
	skele.MoveTo(_akTargetRef)
	(skele as Actor).kill()
	_akTargetRef.removeAllItems(skele, true, true)
	_akTargetRef.Disable(true)
EndEvent

Scriptname GiveCannibalismEffect extends Actor

Spell Property AddCannibalism Auto
Perk Property DA11Cannibalism Auto

Event OnSpellCast(Form akSpell)
	Spell castSpell = akSpell as Spell
	If (castSpell == AddCannibalism)
		Self.addPerk(DA11Cannibalism)
	EndIf
EndEvent
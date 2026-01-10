//=============================================================================
//  ESoundVolume.uc : This class allow to have sound when the player enter
//					   and leave a Volume.  All other volume should derive this
//                     class in order to allow sound designer to reuse other
//                     volume already placed by a level designer
//
//  Copyright 2001 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2001/01/13 * Created by Eric Begin
//============================================================================//
class ESoundVolume extends PhysicsVolume
	native;

var (Sound) array<Sound> m_EntrySound;
var (Sound) array<Sound> m_ExitSound;
var (Sound) ESoundSlot   m_eSoundSlot;
var (Sound) bool		 NPCTrigger;

event PawnEnteredVolume(Pawn Other)
{
    local INT iSoundIndex;
	Super.PawnEnteredVolume(Other);

    if (Other.IsHumanControlled() || NPCTrigger)
	{
        for (iSoundIndex = 0; iSoundIndex < m_EntrySound.Length; iSoundIndex++)
        {
            PlaySound(m_EntrySound[iSoundIndex], m_eSoundSlot);
        }
	}
}

event PawnLeavingVolume(Pawn Other)
{
    local INT iSoundIndex;
	Super.PawnLeavingVolume(Other);

    if (Other.IsHumanControlled() || NPCTrigger)
	{
		for (iSoundIndex = 0; iSoundIndex < m_ExitSound.Length; iSoundIndex++)
        {
            PlaySound(m_ExitSound[iSoundIndex], m_eSoundSlot);
        }
	}
}

defaultproperties
{
    m_eSoundSlot=SLOT_Ambient
}
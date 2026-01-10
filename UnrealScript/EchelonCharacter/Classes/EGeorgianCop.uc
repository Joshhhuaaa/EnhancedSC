//===============================================================================
//  [EGeorgianCop]
//===============================================================================

class EGeorgianCop extends EAIProfessional
	placeable;

#exec OBJ LOAD FILE=..\Sounds\GeorgianCop.uax

//----------------------------------------[David Kalina - 1 May 2002]-----
//
// Description
//		Get appropriate weapon selection animation.
//		CIA Agents use pistols inside their jackets.
//
//------------------------------------------------------------------------
function name GetWeaponSelectAnim()
{
	if (bIsCrouched)
	{
		// weapon selection depends on the handedness of the weapon this AI owns
		switch (WeaponHandedness)
		{
			case 0 :
				return '';

			case 1 :
				return 'DrawCrAlSb1';

			case 2 :
				return 'DrawCrAlBg2';
		}
	}
	else
	{
		// weapon selection depends on the handedness of the weapon this AI owns
		switch (WeaponHandedness)
		{
			case 0 :
				return '';

			case 1 :
				return 'DrawStAlSb1';

			case 2 :
				return 'DrawStAlBg2';
		}
	}
}

//----------------------------------------[David Kalina - 1 May 2002]-----
//
// Description
//		CIA Agents hide their weapons inside their jackets.
//
//------------------------------------------------------------------------
function AttachWeaponAway()
{
	if (CurrentWeapon != none)
	{
		Super.AttachWeaponAway();
		CurrentWeapon.bHidden = true;	// hiding weapon in jacket
	}
}

defaultproperties
{
    GearSoundWalk=Sound'GearCommon.Play_Random_CivilGearWalk'
    GearSoundRun=Sound'GearCommon.Play_Random_CivilGearRun'
    AccuracyDeviation=1.400000
    GearSoundFall=Sound'GearCommon.Play_CivilGearFall'
    Sounds_AttackMove=Sound'GeorgianCop.Play_random_GCPCombatMove'
    Sounds_AttackStop=Sound'GeorgianCop.Play_random_GCPCombatStop'
    Mesh=SkeletalMesh'ENPC.GEPoliceAMesh'
}
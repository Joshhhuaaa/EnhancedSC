//===============================================================================
//  [EAnna]
//===============================================================================

class EAnna extends EAIFemale
	placeable;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	if (Mesh != None)
	{
		m_VisibilityConeAngle = 60.000000;
		m_VisibilityMaxDistance = 800.000000;
		m_VisibilityAngleVertical = 35.00000;
		m_MaxPeripheralVisionDistance = 200.0;
	}
}

defaultproperties
{
    GearSoundWalk=Sound'GearCommon.Play_Random_CivilGearWalk'
    GearSoundRun=Sound'GearCommon.Play_Random_CivilGearRun'
    bCanWhistle=False
    bDontCheckChangedActor=True
    m_VisibilityConeAngle=0.000000
    m_VisibilityMaxDistance=0.000000
    m_VisibilityAngleVertical=0.000000
    m_MaxPeripheralVisionDistance=0.000000
    DrawType=DT_Sprite
}
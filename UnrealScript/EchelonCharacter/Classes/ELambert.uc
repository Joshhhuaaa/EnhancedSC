class ELambert extends EAINonHostile
	placeable;

function PostBeginPlay()
{
	// set bone names
	EyeBoneName = 'B Head';

    Super.PostBeginPlay();
}


function SwitchAnims()
{

	Super.SwitchAnims();

	AWait = 'waitstnmfd0';

}

defaultproperties
{
    GearSoundWalk=Sound'GearCommon.Play_Random_CivilGearWalk'
    GearSoundRun=Sound'GearCommon.Play_Random_CivilGearRun'
    bCanWhistle=false
    bDontCheckChangedActor=true
    m_VisibilityConeAngle=0.000000
    m_VisibilityMaxDistance=0.000000
    m_VisibilityAngleVertical=0.000000
    m_MaxPeripheralVisionDistance=0.000000
    DrawType=DT_Sprite
    CollisionRadius=34.000000
    CollisionHeight=88.000000
}
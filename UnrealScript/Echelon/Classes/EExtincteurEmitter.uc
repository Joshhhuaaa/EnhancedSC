class EExtincteurEmitter extends EConeDamageEmitter;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	PlaySound(Sound'FisherEquipement.Play_GasGrenadeExplosion', SLOT_SFX);
	SetBase(Owner);
}

function StopDamage()
{
	PlaySound(Sound'FisherEquipement.Stop_GasGrenadeExplosion', SLOT_SFX);
	Kill();
	Super.StopDamage();
}

defaultproperties
{
    SprayDistance=225.000000
    SprayDamage=4
    StopDamageTime=5.000000
	Begin Object Class=SpriteEmitter Name=ExtincteurEmitter0
        Acceleration=(Z=200.000000)
        UseCollision=True
        ExtentMultiplier=(X=0.200000,Y=0.200000,Z=0.200000)
        FadeOutStartTime=0.100000
        FadeOut=True
        FadeInEndTime=0.100000
        FadeIn=True
        MaxParticles=50
        ResetAfterChange=True
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=0.100000))
        DampRotation=True
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=40.000000,Max=40.000000))
        UniformSize=True
        ParticlesPerSecond=10.000000
        InitialParticlesPerSecond=10.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'ETexSFX.smoke.Grey_Dust'
        LifetimeRange=(Min=0.500000,Max=0.750000)
        StartVelocityRange=(X=(Min=400.000000,Max=500.000000))
        VelocityLossRange=(X=(Min=2.000000,Max=2.000000),Y=(Min=2.000000,Max=2.000000),Z=(Min=2.000000,Max=2.000000))
        Name="ExtincteurEmitter0"
    End Object
    Emitters(0)=SpriteEmitter'ExtincteurEmitter0'
}
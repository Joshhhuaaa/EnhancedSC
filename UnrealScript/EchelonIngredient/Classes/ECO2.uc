class ECO2 extends EConeDamageEmitter;

defaultproperties
{
    SprayDistance=300.000000
    SprayDamage=4
    StopDamageTime=5.000000
    Begin Object Class=SpriteEmitter Name=CO2
        Acceleration=(Z=2.000000)
        UseCollision=True
        UseColorScale=True
        ColorScale(0)=(RelativeTime=1.000000)
        ColorScale(1)=(RelativeTime=1.000000)
        FadeOutStartTime=1.000000
        FadeOut=True
        FadeInEndTime=1.000000
        FadeIn=True
        MaxParticles=20
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=0.050000))
        DampRotation=True
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.250000)
        SizeScale(1)=(RelativeTime=10.000000,RelativeSize=50.000000)
        StartSizeRange=(X=(Min=100.000000,Max=100.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
        UniformSize=True
        InitialParticlesPerSecond=8.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Brighten
        Texture=Texture'ETexSFX.smoke.Grey_Dust'
        LifetimeRange=(Min=5.000000,Max=12.000000)
        StartVelocityRange=(X=(Min=100.000000,Max=200.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-10.000000,Max=5.000000))
        VelocityLossRange=(X=(Min=0.100000,Max=1.000000),Y=(Min=0.100000,Max=1.000000))
        Name="CO2"
    End Object
    Emitters(0)=SpriteEmitter'CO2'
}
class ESmokeCloud extends Emitter
	notplaceable;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetBase(Owner);
}

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SmokeCloud
        FadeOut=True
        FadeIn=True
        MaxParticles=20
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.050000)
        SizeScale(1)=(RelativeTime=0.200000,RelativeSize=3.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=3.000000)
        StartSizeRange=(X=(Min=100.000000,Max=100.000000),Y=(Min=100.000000,Max=100.000000),Z=(Min=100.000000,Max=100.000000))
        UniformSize=True
        InitialParticlesPerSecond=5.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.smoke.SFX_expsmoke'
        LifetimeRange=(Min=10.000000,Max=10.000000)
        StartVelocityRange=(X=(Min=200.000000,Max=-200.000000),Y=(Min=200.000000,Max=-200.000000),Z=(Min=100.000000,Max=100.000000))
        VelocityLossRange=(X=(Max=2.000000),Y=(Max=2.000000),Z=(Min=0.400000,Max=0.400000))
        Name="SmokeCloud"
    End Object
    Emitters(0)=SpriteEmitter'SmokeCloud'
}
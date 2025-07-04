class EExplodeDoorsSEV extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=ExplodeDoorsSEV
        Acceleration=(Z=200.000000)
        FadeOutStartTime=0.700000
        FadeOut=True
        MaxParticles=20
        ResetAfterChange=True
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(1)=(RelativeTime=0.000005,RelativeSize=8.000000)
        SizeScale(2)=(RelativeTime=0.800000,RelativeSize=2.000000)
        SizeScale(3)=(RelativeTime=1.000000)
        StartSizeRange=(X=(Min=10.000000))
        UniformSize=True
        InitialParticlesPerSecond=5000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Brighten
        Texture=Texture'ETexSFX.Fire.ExplodeDoors'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=True
        LifetimeRange=(Min=1.000000,Max=1.000000)
        StartVelocityRange=(X=(Min=-500.000000,Max=500.000000),Y=(Max=1000.000000),Z=(Min=50.000000,Max=200.000000))
        VelocityLossRange=(X=(Min=3.000000,Max=8.000000))
        Name="ExplodeDoorsSEV"
    End Object
    Emitters(0)=SpriteEmitter'ExplodeDoorsSEV'
}
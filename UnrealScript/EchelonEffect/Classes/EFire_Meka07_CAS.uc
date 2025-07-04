class EFire_Meka07_CAS extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=Fire_Meka07_CAS
        Acceleration=(Z=50.000000)
        FadeOutStartTime=2.000000
        FadeOut=True
        MaxParticles=75
        ResetAfterChange=True
        RespawnDeadParticles=False
        StartLocationRange=(X=(Min=-25.000000,Max=25.000000),Y=(Min=-200.000000,Max=250.000000),Z=(Max=200.000000))
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=2.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=30.000000,Max=60.000000))
        UniformSize=True
        InitialParticlesPerSecond=5.000000
        AutomaticInitialSpawning=False
        Texture=Texture'ETexSFX.Fire.FireSam'
        TextureUSubdivisions=5
        TextureVSubdivisions=5
        BlendBetweenSubdivisions=True
        LifetimeRange=(Min=2.000000)
        StartVelocityRange=(Z=(Max=-10.000000))
        Name="Fire_Meka07_CAS"
    End Object
    Emitters(0)=SpriteEmitter'Fire_Meka07_CAS'
}
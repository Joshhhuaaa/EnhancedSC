class EBridgeEmitter extends Emitter;

defaultproperties
{
    Begin Object Class=MeshEmitter Name=MeshEmitter28
        StaticMesh=StaticMesh'EMeshSFX.Item.CAS_PART_Bridge01'
        RenderTwoSided=True
        Acceleration=(Z=-2000.000000)
        MaxParticles=2
        RespawnDeadParticles=False
        StartLocationRange=(X=(Min=50.000000,Max=50.000000),Z=(Min=50.000000,Max=50.000000))
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=0.250000),Y=(Min=0.100000,Max=0.500000),Z=(Max=0.250000))
        StartSizeRange=(X=(Min=2.000000,Max=3.000000),Y=(Min=2.000000,Max=3.000000),Z=(Min=2.000000,Max=3.000000))
        InitialParticlesPerSecond=5000.000000
        AutomaticInitialSpawning=False
        StartVelocityRange=(X=(Min=-1000.000000,Max=1000.000000),Y=(Min=-1000.000000,Max=1000.000000),Z=(Min=-500.000000,Max=2000.000000))
        VelocityLossRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
        Name="MeshEmitter28"
    End Object
    Emitters(0)=MeshEmitter'MeshEmitter28'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter19
        FadeOutStartTime=0.800000
        FadeOut=True
        ResetAfterChange=True
        RespawnDeadParticles=False
        StartLocationRange=(X=(Min=-50.000000,Max=-50.000000),Y=(Min=-300.000000,Max=-300.000000),Z=(Min=400.000000,Max=400.000000))
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=0.250000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=100.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=500.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=250.000000)
        StartSizeRange=(X=(Min=2.000000,Max=4.000000))
        UniformSize=True
        InitialParticlesPerSecond=80.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Brighten
        Texture=Texture'ETexSFX.Fire.ExplodeDoors'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=True
        LifetimeRange=(Min=0.750000,Max=1.500000)
        StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-200.000000,Max=600.000000))
        Name="SpriteEmitter19"
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter19'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter22
        Acceleration=(Z=1000.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255))
        ColorScale(1)=(RelativeTime=2.000000)
        FadeOutStartTime=-10.000000
        FadeOut=True
        ResetAfterChange=True
        RespawnDeadParticles=False
        StartLocationRange=(Y=(Min=500.000000,Max=500.000000),Z=(Min=850.000000,Max=850.000000))
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=5.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=200.000000,Max=250.000000))
        UniformSize=True
        InitialParticlesPerSecond=1000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Darken
        Texture=Texture'ETexSFX.smoke.SFX_Dark_Smoke'
        BlendBetweenSubdivisions=True
        StartVelocityRange=(X=(Min=-5000.000000,Max=5000.000000),Y=(Min=-5000.000000,Max=5000.000000),Z=(Min=-1000.000000,Max=15000.000000))
        VelocityLossRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
        Name="SpriteEmitter22"
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter22'
}
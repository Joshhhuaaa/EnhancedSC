class EDoubleDoorsSevEmitter extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=EDoubleDoorsSevEmitterA
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
        StartSizeRange=(X=(Min=75.000000,Max=100.000000))
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
        Name="EDoubleDoorsSevEmitterA"
    End Object
    Emitters(0)=SpriteEmitter'EDoubleDoorsSevEmitterA'
    Begin Object Class=MeshEmitter Name=EDoubleDoorsSevEmitterB
        StaticMesh=StaticMesh'EMeshSFX.Item.ParticuleWDoorParts1'
        RenderTwoSided=True
        Acceleration=(Y=100.000000,Z=-500.000000)
        MaxParticles=100
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=1.000000),Z=(Max=1.000000))
        DampRotation=True
        StartSizeRange=(X=(Min=0.050000,Max=0.100000),Y=(Min=0.050000,Max=0.100000),Z=(Min=0.050000,Max=0.100000))
        InitialParticlesPerSecond=500.000000
        AutomaticInitialSpawning=False
        InitialTimeRange=(Min=-20.000000,Max=-20.000000)
        LifetimeRange=(Min=20.000000,Max=20.000000)
        StartVelocityRange=(X=(Min=50.000000,Max=1000.000000),Y=(Min=250.000000,Max=500.000000),Z=(Min=-50.000000,Max=800.000000))
        Name="EDoubleDoorsSevEmitterB"
    End Object
    Emitters(1)=MeshEmitter'EchelonEffect.EDoubleDoorsSevEmitterB'
    Begin Object Class=MeshEmitter Name=EDoubleDoorsSevEmitterC
        StaticMesh=StaticMesh'EMeshSFX.Item.ParticuleWDoorParts1'
        RenderTwoSided=True
        Acceleration=(Y=50.000000,Z=-500.000000)
        MaxParticles=20
        ResetAfterChange=True
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=2.000000),Y=(Max=2.000000),Z=(Max=2.000000))
        DampRotation=True
        RotationDampingFactorRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
        StartSizeRange=(X=(Min=0.250000),Y=(Min=0.250000),Z=(Min=0.250000))
        InitialParticlesPerSecond=5000.000000
        AutomaticInitialSpawning=False
        InitialTimeRange=(Min=-20.000000,Max=-20.000000)
        LifetimeRange=(Min=20.000000,Max=20.000000)
        StartVelocityRange=(X=(Max=1000.000000),Y=(Min=200.000000,Max=500.000000),Z=(Min=-50.000000,Max=700.000000))
        Name="EDoubleDoorsSevEmitterC"
    End Object
    Emitters(2)=MeshEmitter'EchelonEffect.EDoubleDoorsSevEmitterC'
}
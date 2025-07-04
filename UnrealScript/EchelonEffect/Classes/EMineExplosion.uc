class EMineExplosion extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        Acceleration=(Z=-980.000000)
        FadeOut=True
        MaxParticles=25
        ResetAfterChange=True
        RespawnDeadParticles=False
        StartSpinRange=(X=(Min=-0.100000,Max=0.100000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
        StartSizeRange=(X=(Max=110.000000))
        UniformSize=True
        InitialParticlesPerSecond=50000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.smoke.Mine_DUST'
        LifetimeRange=(Min=2.000000,Max=2.000000)
        StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=500.000000,Max=1500.000000))
        VelocityLossRange=(Z=(Min=1.000000,Max=1.000000))
        Name="SpriteEmitter2"
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter2'
    Begin Object Class=MeshEmitter Name=MeshEmitter4
        StaticMesh=StaticMesh'EMeshSFX.Item.WallMine_Break2'
        RenderTwoSided=True
        Acceleration=(Z=-980.000000)
        UseCollision=True
        DampingFactorRange=(X=(Max=0.250000),Y=(Max=0.250000),Z=(Max=0.250000))
        MaxParticles=50
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        DampRotation=True
        StartSizeRange=(X=(Min=0.100000,Max=2.000000),Y=(Min=0.100000,Max=2.000000),Z=(Min=0.100000,Max=2.000000))
        InitialParticlesPerSecond=5000.000000
        AutomaticInitialSpawning=False
        LifetimeRange=(Min=10.000000,Max=10.000000)
        StartVelocityRange=(X=(Min=-300.000000,Max=300.000000),Y=(Min=-300.000000,Max=300.000000),Z=(Min=100.000000,Max=1500.000000))
        Name="MeshEmitter4"
    End Object
    Emitters(1)=MeshEmitter'EchelonEffect.MeshEmitter4'
}
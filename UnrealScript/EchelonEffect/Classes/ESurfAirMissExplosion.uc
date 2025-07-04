class ESurfAirMissExplosion extends Emitter;

defaultproperties
{
    Begin Object Class=MeshEmitter Name=MeshEmitter56
        StaticMesh=StaticMesh'EMeshSFX.Item.SurfAirMiss01PART'
        RenderTwoSided=True
        Acceleration=(Z=-980.000000)
        ExtentMultiplier=(Z=0.000000)
        DampingFactorRange=(X=(Max=0.250000),Y=(Max=0.250000),Z=(Max=0.250000))
        MaxParticles=25
        RespawnDeadParticles=False
        SpinParticles=True
        RotationOffset=(Pitch=10,Yaw=10,Roll=10)
        SpinsPerSecondRange=(X=(Min=-4.000000,Max=4.000000),Y=(Min=-4.000000,Max=4.000000),Z=(Min=-4.000000,Max=4.000000))
        DampRotation=True
        RotationDampingFactorRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
        StartSizeRange=(X=(Max=3.000000),Y=(Max=3.000000),Z=(Max=3.000000))
        UniformSize=True
        InitialParticlesPerSecond=5000.000000
        AutomaticInitialSpawning=False
        LifetimeRange=(Min=1000.000000,Max=1000.000000)
        StartVelocityRange=(X=(Min=-500.000000,Max=500.000000),Y=(Min=-500.000000,Max=500.000000),Z=(Min=-500.000000,Max=1000.000000))
        Name="MeshEmitter56"
    End Object
    Emitters(0)=MeshEmitter'EchelonEffect.MeshEmitter56'
    Begin Object Class=MeshEmitter Name=MeshEmitter57
        StaticMesh=StaticMesh'EMeshSFX.Item.SurfAirMiss02PART'
        RenderTwoSided=True
        Acceleration=(Z=-980.000000)
        UseCollision=True
        DampingFactorRange=(X=(Max=0.250000),Y=(Max=0.250000),Z=(Max=0.250000))
        MaxParticles=1
        RespawnDeadParticles=False
        SpinParticles=True
        RotationOffset=(Pitch=10,Yaw=10,Roll=10)
        SpinsPerSecondRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-2.000000,Max=2.000000))
        DampRotation=True
        RotationDampingFactorRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
        InitialParticlesPerSecond=5000.000000
        AutomaticInitialSpawning=False
        LifetimeRange=(Min=1000.000000,Max=1000.000000)
        StartVelocityRange=(X=(Min=-250.000000,Max=25.000000),Y=(Min=-250.000000,Max=250.000000),Z=(Min=-500.000000,Max=500.000000))
        Name="MeshEmitter57"
    End Object
    Emitters(1)=MeshEmitter'EchelonEffect.MeshEmitter57'
    Begin Object Class=MeshEmitter Name=MeshEmitter58
        StaticMesh=StaticMesh'EMeshSFX.Item.SurfAirMiss03PART'
        RenderTwoSided=True
        Acceleration=(Z=-980.000000)
        DampingFactorRange=(X=(Max=0.250000),Y=(Max=0.250000),Z=(Max=0.250000))
        MaxParticles=25
        RespawnDeadParticles=False
        SpinParticles=True
        RotationOffset=(Pitch=10,Yaw=10,Roll=10)
        SpinsPerSecondRange=(X=(Min=-4.000000,Max=4.000000),Y=(Min=-4.000000,Max=4.000000),Z=(Min=-4.000000,Max=4.000000))
        DampRotation=True
        RotationDampingFactorRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
        StartSizeRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-2.000000,Max=2.000000))
        InitialParticlesPerSecond=5000.000000
        AutomaticInitialSpawning=False
        LifetimeRange=(Min=1000.000000,Max=1000.000000)
        StartVelocityRange=(X=(Min=-500.000000,Max=500.000000),Y=(Min=-500.000000,Max=500.000000),Z=(Min=100.000000,Max=1000.000000))
        Name="MeshEmitter58"
    End Object
    Emitters(2)=MeshEmitter'EchelonEffect.MeshEmitter58'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter77
        Acceleration=(Z=-50.000000)
        FadeOutStartTime=8.000000
        FadeOut=True
        FadeInEndTime=8.000000
        FadeIn=True
        MaxParticles=5
        ResetAfterChange=True
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=0.001000,Max=0.100000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.400000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=250.000000,Max=500.000000))
        UniformSize=True
        InitialParticlesPerSecond=5000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Darken
        Texture=Texture'ETexSFX.smoke.SFX_Dark_Smoke'
        LifetimeRange=(Min=20.000000,Max=20.000000)
        StartVelocityRange=(X=(Min=-40.000000,Max=40.000000),Y=(Min=-40.000000,Max=40.000000),Z=(Min=-25.000000,Max=150.000000))
        VelocityLossRange=(X=(Max=0.100000),Y=(Max=0.100000),Z=(Max=0.100000))
        Name="SpriteEmitter77"
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter77'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter78
        Acceleration=(Z=10.000000)
        FadeOut=True
        MaxParticles=25
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=0.050000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=2.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
        StartSizeRange=(X=(Min=100.000000,Max=200.000000))
        UniformSize=True
        InitialParticlesPerSecond=100000.000000
        AutomaticInitialSpawning=False
        Texture=Texture'ETexSFX.Fire.ExplodeDoors'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        LifetimeRange=(Min=2.000000)
        StartVelocityRange=(X=(Min=-750.000000,Max=750.000000),Y=(Min=-750.000000,Max=750.000000),Z=(Min=-500.000000,Max=2500.000000))
        VelocityLossRange=(X=(Min=2.000000,Max=4.000000),Y=(Min=2.000000,Max=4.000000),Z=(Min=2.000000,Max=4.000000))
        IsGlowing=True
        Name="SpriteEmitter78"
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter78'
}
class EGrenadeExplosion extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=GrenadeExplosion0
        MaxParticles=2
        ResetAfterChange=True
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        StartSizeRange=(X=(Min=100.000000,Max=400.000000))
        UniformSize=True
        InitialParticlesPerSecond=50.000000
        AutomaticInitialSpawning=False
        Texture=Texture'ETexSFX.Fire.SFX_WalMineEX'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=1.000000,Max=1.000000)
        IsGlowing=True
        Name="GrenadeExplosion0"
    End Object
    Emitters(0)=SpriteEmitter'GrenadeExplosion0'
    Begin Object Class=MeshEmitter Name=GrenadeExplosion1
        StaticMesh=StaticMesh'EMeshSFX.Item.WallMine_Break1'
        RenderTwoSided=True
        Acceleration=(Z=-980.000000)
        UseCollision=True
        DampingFactorRange=(X=(Min=0.100000,Max=0.500000),Y=(Min=0.100000,Max=0.500000),Z=(Min=0.100000,Max=0.500000))
        MaxParticles=25
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        DampRotation=True
        StartSizeRange=(X=(Min=0.100000))
        InitialParticlesPerSecond=500.000000
        AutomaticInitialSpawning=False
        StartVelocityRange=(X=(Min=-250.000000,Max=250.000000),Y=(Min=-250.000000,Max=250.000000),Z=(Max=1000.000000))
        Name="GrenadeExplosion1"
    End Object
    Emitters(1)=MeshEmitter'EchelonEffect.GrenadeExplosion1'
    Begin Object Class=SpriteEmitter Name=GrenadeExplosion2
        Acceleration=(Y=-100.000000,Z=5.000000)
        FadeOutStartTime=0.400000
        FadeOut=True
        FadeInEndTime=0.400000
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        StartSizeRange=(X=(Max=200.000000))
        UniformSize=True
        InitialParticlesPerSecond=500.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.smoke.SFX_expsmoke'
        StartVelocityRange=(X=(Min=-250.000000,Max=250.000000),Y=(Min=-250.000000,Max=250.000000),Z=(Min=250.000000,Max=500.000000))
        VelocityLossRange=(X=(Min=1.000000,Max=2.000000),Y=(Min=1.000000,Max=2.000000),Z=(Min=1.000000,Max=2.000000))
        Name="GrenadeExplosion2"
    End Object
    Emitters(2)=SpriteEmitter'GrenadeExplosion2'
}
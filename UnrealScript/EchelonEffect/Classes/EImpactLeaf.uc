class EImpactLeaf extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=ImpactLeaf
        UseDirectionAs=PTDU_Normal
        ProjectionNormal=(X=0.750000)
        Acceleration=(Y=-10.000000,Z=-300.000000)
        UseCollision=True
        DampingFactorRange=(Z=(Max=0.010000))
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        MaxParticles=5
        RespawnDeadParticles=False
        SpinParticles=True
        RotationOffset=(Pitch=50,Yaw=42,Roll=25)
        SpinsPerSecondRange=(X=(Max=0.250000))
        StartSpinRange=(X=(Max=1.000000))
        DampRotation=True
        StartSizeRange=(X=(Min=2.000000,Max=4.000000))
        UniformSize=True
        InitialParticlesPerSecond=100000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'EGO_Tex.CHI_TexGO.GO_Tree_LeafA'
        LifetimeRange=(Min=10.000000,Max=10.000000)
        StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-500.000000,Max=500.000000))
        VelocityLossRange=(X=(Min=2.000000,Max=4.000000),Y=(Min=2.000000,Max=4.000000),Z=(Min=5.000000,Max=10.000000))
        Name="ImpactLeaf"
    End Object
    Emitters(0)=SpriteEmitter'ImpactLeaf'
    bUnlit=False
}
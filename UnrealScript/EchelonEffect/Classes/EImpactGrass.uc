class EImpactGrass extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=ImpactGrass
        UseDirectionAs=PTDU_RightAndNormal
        ProjectionNormal=(X=1.000000,Y=1.000000)
        Acceleration=(Z=-980.000000)
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        MaxParticles=50
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=1.000000))
        StartSizeRange=(X=(Min=0.500000),Y=(Min=2.500000,Max=5.000000),Z=(Min=0.500000))
        InitialParticlesPerSecond=100000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'EGO_Tex.PAL_TexGO.flowerleaf_PAL'
        StartVelocityRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Max=300.000000))
        VelocityLossRange=(X=(Min=1.000000,Max=2.000000),Y=(Min=1.000000,Max=2.000000))
        Name="ImpactGrass"
    End Object
    Emitters(0)=SpriteEmitter'ImpactGrass'
    bUnlit=False
}
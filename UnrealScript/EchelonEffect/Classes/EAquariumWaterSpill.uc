class EAquariumWaterSpill extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=AquariumWaterSpill
        UseDirectionAs=PTDU_Normal
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        FadeOutStartTime=3.000000
        FadeOut=True
        FadeInEndTime=3.000000
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        DampRotation=True
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=5.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=12.000000)
        StartSizeRange=(X=(Min=10.000000,Max=20.000000),Y=(Min=10.000000,Max=20.000000),Z=(Min=10.000000,Max=20.000000))
        InitialParticlesPerSecond=50000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.water.Aqua_Eau'
        LifetimeRange=(Min=6.000000,Max=6.000000)
        StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000))
        VelocityLossRange=(X=(Max=3.000000),Y=(Max=3.000000))
        RelativeWarmupTime=-500.000000
        Name="AquariumWaterSpill"
    End Object
    Emitters(0)=SpriteEmitter'AquariumWaterSpill'
    bUnlit=false
}
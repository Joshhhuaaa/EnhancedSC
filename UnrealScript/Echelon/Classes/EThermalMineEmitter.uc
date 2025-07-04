class EThermalMineEmitter extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitterThermal
        UseDirectionAs=PTDU_Normal
        FadeOutStartTime=3.500000
        FadeOut=True
        MaxParticles=1
        ResetAfterChange=True
        OnlyVisibleInThermalVisionFallback=True
        AutoDestroy=False
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeTime=0.150000)
        SizeScale(1)=(RelativeTime=1.000000)
        StartSizeRange=(X=(Min=50.000000,Max=50.000000))
        UniformSize=True
        InitialParticlesPerSecond=100000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.Fire.landmineheat'
        ThermalVisionFallbackDrawStyle=PTDS_AlphaBlend
        ThermalVisionFallbackTexture=Texture'ETexSFX.Fire.landmineheat'
        Name="SpriteEmitterThermal"
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitterThermal'
}
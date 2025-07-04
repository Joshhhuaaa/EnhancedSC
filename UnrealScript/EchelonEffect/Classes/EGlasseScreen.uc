class EGlasseScreen extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=GlasseScreen2
        Acceleration=(Z=-950.000000)
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        FadeOutStartTime=0.500000
        FadeOut=True
        MaxParticles=60
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=1.000000),Z=(Max=1.000000))
        DampRotation=True
        StartSizeRange=(X=(Min=0.300000,Max=3.000000))
        UniformSize=True
        InitialParticlesPerSecond=1500.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.Window.SFX_BGlass'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        UseSubdivisionScale=True
        LifetimeRange=(Min=5.000000,Max=5.000000)
        StartVelocityRange=(X=(Min=100.000000,Max=-500.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=-50.000000,Max=400.000000))
        Name="GlasseScreen2"
    End Object
    Emitters(0)=SpriteEmitter'GlasseScreen2'
    bUnlit=false
}
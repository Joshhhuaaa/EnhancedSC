class EGlassSmallParticleB extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=GlassSmallParticleB
        Acceleration=(Z=-950.000000)
        UseCollision=True
        DampingFactorRange=(X=(Min=0.900000,Max=0.900000),Y=(Min=0.900000,Max=0.900000),Z=(Min=0.500000,Max=0.600000))
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        FadeOutStartTime=0.900000
        FadeOut=True
        MaxParticles=5
        ResetAfterChange=True
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
        DampRotation=True
        RotationDampingFactorRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        UseRegularSizeScale=False
        StartSizeRange=(X=(Min=0.500000))
        UniformSize=True
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.Window.SFX_BGlass'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseSubdivisionScale=True
        UseRandomSubdivision=True
        LifetimeRange=(Min=0.100000,Max=5.000000)
        StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-10.000000,Max=500.000000))
        Name="GlassSmallParticleB"
    End Object
    Emitters(0)=SpriteEmitter'GlassSmallParticleB'
    bUnlit=false
}
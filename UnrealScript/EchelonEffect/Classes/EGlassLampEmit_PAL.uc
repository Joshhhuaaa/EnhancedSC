class EGlassLampEmit_PAL extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter58
        Acceleration=(Z=-980.000000)
        UseCollision=True
        DampingFactorRange=(X=(Min=0.010000),Y=(Min=0.010000),Z=(Min=0.001000,Max=0.400000))
        UseColorScale=True
        ColorScale(0)=(Color=(G=164,R=204))
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        FadeOutStartTime=0.900000
        FadeOut=True
        MaxParticles=40
        ResetAfterChange=True
        RespawnDeadParticles=False
        StartLocationRange=(X=(Min=-100.000000,Max=100.000000),Z=(Min=-50.000000,Max=50.000000))
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=10.000000,Max=10.000000)
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-10.000000,Max=10.000000))
        DampRotation=True
        RotationDampingFactorRange=(X=(Min=0.010000,Max=1.000000),Y=(Min=0.010000,Max=1.000000),Z=(Min=0.001000,Max=1.000000))
        UseRegularSizeScale=False
        StartSizeRange=(X=(Min=2.000000,Max=4.000000))
        UniformSize=True
        InitialParticlesPerSecond=5000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.bullet_impact.SFX_BGlass_Yelllow'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseSubdivisionScale=True
        UseRandomSubdivision=True
        LifetimeRange=(Min=10.000000,Max=10.000000)
        StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=-150.000000,Max=500.000000))
        VelocityLossRange=(X=(Max=1.000000))
        Name="SpriteEmitter58"
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter58'
    bUnlit=False
}
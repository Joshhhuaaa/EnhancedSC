class ERedLamo_PAL extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=RedLamo_PAL
        Acceleration=(Z=-980.000000)
        UseCollision=True
        DampingFactorRange=(Z=(Min=0.200000,Max=0.400000))
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        FadeOutStartTime=0.900000
        FadeOut=True
        MaxParticles=15
        ResetAfterChange=True
        RespawnDeadParticles=False
        StartLocationShape=PTLS_Sphere
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
        DampRotation=True
        RotationDampingFactorRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        UseRegularSizeScale=False
        StartSizeRange=(X=(Min=0.100000,Max=6.000000))
        UniformSize=True
        InitialParticlesPerSecond=5000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'EGO_Tex.PAL_TexGO.GO_redlamp_PAL'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseSubdivisionScale=True
        UseRandomSubdivision=True
        LifetimeRange=(Min=10.000000,Max=10.000000)
        StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-150.000000,Max=300.000000))
        VelocityLossRange=(X=(Max=1.000000))
        Name="RedLamo_PAL"
    End Object
    Emitters(0)=SpriteEmitter'RedLamo_PAL'
    bUnlit=false
}
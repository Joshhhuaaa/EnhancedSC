class ECrystalVase extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=Cystalevase
        Acceleration=(Z=-980.000000)
        UseCollision=True
        DampingFactorRange=(Z=(Min=0.200000,Max=0.400000))
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        FadeOutStartTime=0.900000
        FadeOut=True
        MaxParticles=50
        ResetAfterChange=True
        RespawnDeadParticles=False
        StartLocationRange=(X=(Min=-100.000000,Max=100.000000),Z=(Min=-50.000000,Max=50.000000))
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=10.000000,Max=10.000000)
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
        DampRotation=True
        RotationDampingFactorRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        UseRegularSizeScale=False
        StartSizeRange=(X=(Max=5.000000))
        UniformSize=True
        InitialParticlesPerSecond=5000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'EGO_Tex.PAL_TexGO.crystalvase_PAL_PARTS'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        UseSubdivisionScale=True
        UseRandomSubdivision=True
        LifetimeRange=(Min=10.000000,Max=10.000000)
        StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=-100.000000,Max=300.000000))
        VelocityLossRange=(X=(Max=1.000000))
        Name="Cystalevase"
    End Object
    Emitters(0)=SpriteEmitter'Cystalevase'
    bUnlit=false
}
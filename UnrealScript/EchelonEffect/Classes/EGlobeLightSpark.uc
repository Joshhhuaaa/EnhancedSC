class EGlobeLightSpark extends Emitter;

defaultproperties
{
    Emitters(0)=none
    Begin Object Class=SpriteEmitter Name=GlobeGlass
        Acceleration=(Z=-950.000000)
        UseCollision=True
        DampingFactorRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.200000,Max=0.400000))
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        FadeOutStartTime=0.900000
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
        DampRotation=True
        RotationDampingFactorRange=(X=(Max=10.000000),Y=(Max=10.000000),Z=(Max=10.000000))
        UseRegularSizeScale=False
        StartSizeRange=(X=(Min=0.500000,Max=3.000000))
        UniformSize=True
        InitialParticlesPerSecond=1000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.Window.SFX_BGlass'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseSubdivisionScale=True
        UseRandomSubdivision=True
        LifetimeRange=(Min=10.000000,Max=10.000000)
        StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Max=200.000000))
        VelocityLossRange=(X=(Max=1.000000))
        Name="GlobeGlass"
    End Object
    Emitters(1)=SpriteEmitter'GlobeGlass'
    bUnlit=False
}
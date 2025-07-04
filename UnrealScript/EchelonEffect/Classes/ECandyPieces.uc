class ECandyPieces extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=CandyPieces
        Acceleration=(Z=-300.000000)
        UseCollision=True
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        FadeOutStartTime=0.990000
        FadeOut=True
        FadeIn=True
        MaxParticles=7
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000))
        DampRotation=True
        StartSizeRange=(X=(Min=0.500000,Max=6.000000),Y=(Min=5.000000,Max=5.000000),Z=(Min=5.000000,Max=5.000000))
        UniformSize=True
        InitialParticlesPerSecond=1000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.Paper.candypiece'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseRandomSubdivision=True
        LifetimeRange=(Min=7.000000,Max=7.000000)
        StartVelocityRange=(X=(Min=-300.000000,Max=300.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-300.000000,Max=300.000000))
        VelocityLossRange=(X=(Min=4.000000,Max=10.000000),Y=(Min=1.500000,Max=1.500000),Z=(Min=4.000000,Max=7.000000))
        Name="CandyPieces"
    End Object
    Emitters(0)=SpriteEmitter'CandyPieces'
    bUnlit=false
}
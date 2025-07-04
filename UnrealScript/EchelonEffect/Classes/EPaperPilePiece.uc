class EPaperPilePiece extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=PaperPilePiece
        Acceleration=(Z=-300.000000)
        UseCollision=True
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        MaxParticles=5
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        UseRegularSizeScale=False
        StartSizeRange=(X=(Min=2.000000,Max=6.000000))
        UniformSize=True
        InitialParticlesPerSecond=500.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.Paper.SFX_paperpile'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        UseRandomSubdivision=True
        LifetimeRange=(Min=1.000000,Max=20.000000)
        StartVelocityRange=(X=(Min=-300.000000,Max=300.000000),Y=(Min=-300.000000,Max=300.000000),Z=(Min=600.000000,Max=1000.000000))
        VelocityLossRange=(X=(Min=1.000000,Max=9.000000),Y=(Min=1.000000,Max=9.000000),Z=(Min=1.000000,Max=10.000000))
        Name="PaperPilePiece"
    End Object
    Emitters(0)=SpriteEmitter'PaperPilePiece'
    bUnlit=false
}
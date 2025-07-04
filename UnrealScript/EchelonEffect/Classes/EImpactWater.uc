class EImpactWater extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=ImpactWater
        Acceleration=(Z=-100.000000)
        FadeOutStartTime=-4.000000
        FadeOut=True
        MaxParticles=20
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=0.100000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeTime=-10.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
        StartSizeRange=(X=(Min=5.000000,Max=10.000000))
        UniformSize=True
        InitialParticlesPerSecond=100000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.water.WaterGicleur4'
        TextureVSubdivisions=1
        LifetimeRange=(Min=1.000000,Max=1.000000)
        StartVelocityRange=(X=(Min=-25.000000,Max=25.000000),Y=(Min=-25.000000,Max=25.000000),Z=(Max=300.000000))
        VelocityLossRange=(Z=(Min=3.000000,Max=6.000000))
        Name="ImpactWater"
    End Object
    Emitters(0)=SpriteEmitter'ImpactWater'
}
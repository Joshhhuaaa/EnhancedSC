class EImpactSnow extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=Emitter_Bullet_Impact_Snow
        Acceleration=(X=50.000000)
        FadeOut=True
        MaxParticles=25
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=0.100000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeTime=-10.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=5.000000,Max=10.000000))
        UniformSize=True
        InitialParticlesPerSecond=100000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Brighten
        Texture=Texture'ETexSFX.snow.SFX_Snow_Push'
        TextureVSubdivisions=1
        LifetimeRange=(Min=1.000000,Max=1.000000)
        StartVelocityRange=(X=(Min=-25.000000,Max=25.000000),Y=(Min=-25.000000,Max=25.000000),Z=(Max=300.000000))
        VelocityLossRange=(Z=(Min=3.000000,Max=6.000000))
        Name="Emitter_Bullet_Impact_Snow"
    End Object
    Emitters(0)=SpriteEmitter'Emitter_Bullet_Impact_Snow'
}
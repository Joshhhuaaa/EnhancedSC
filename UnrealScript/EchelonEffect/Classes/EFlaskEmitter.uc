class EFlaskEmitter extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=FlaskEmitter
        UseDirectionAs=PTDU_Normal
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        MaxParticles=5
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.300000,RelativeSize=4.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=4.000000)
        StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000))
        InitialParticlesPerSecond=20.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.water.SFX_oil'
        LifetimeRange=(Min=100.000000,Max=100.000000)
        StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000))
        VelocityLossRange=(X=(Min=0.400000,Max=0.400000),Y=(Min=0.400000,Max=0.400000))
        Name="FlaskEmitter"
    End Object
    Emitters(0)=SpriteEmitter'FlaskEmitter'
    bUnlit=false
}
class EBulle extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=Bulle
        Acceleration=(Z=50.000000)
        UseColorScale=True
        ColorScale(0)=(RelativeTime=1.000000,Color=(B=189,G=182,R=69))
        MaxParticles=60
        StartSizeRange=(X=(Min=0.300000))
        UniformSize=True
        Texture=Texture'ETexSFX.water.SFX_bulle'
        LifetimeRange=(Min=1.000000,Max=2.500000)
        StartVelocityRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000))
        Name="Bulle"
    End Object
    Emitters(0)=SpriteEmitter'Bulle'
}
class ESparkEmitter extends Emitter;

defaultproperties
{
    Begin Object Class=SparkEmitter Name=SparkEmitter0
        LineSegmentsRange=(Min=0.050000,Max=0.050000)
        TimeBeforeVisibleRange=(Min=0.050000,Max=0.050000)
        TimeBetweenSegmentsRange=(Min=0.001000,Max=0.075000)
        Acceleration=(Z=-980.000000)
        UseCollision=True
        UseColorScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=199,G=102,R=65))
        ColorScaleRepeats=2.000000
        MaxParticles=5
        RespawnDeadParticles=False
        Disabled=True
        InitialParticlesPerSecond=5000.000000
        AutomaticInitialSpawning=False
        Texture=Texture'ETexSFX.Fire.SFX_spark'
        LifetimeRange=(Min=1.000000,Max=2.000000)
        StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=50.000000,Max=500.000000))
        Name="SparkEmitter0"
    End Object
    Emitters(0)=SparkEmitter'EchelonEffect.SparkEmitter0'
}
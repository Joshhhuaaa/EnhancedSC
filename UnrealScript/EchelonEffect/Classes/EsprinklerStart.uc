class EsprinklerStart extends Emitter;

defaultproperties
{
    Begin Object Class=SparkEmitter Name=sprinklerStart
        LineSegmentsRange=(Min=0.500000,Max=0.500000)
        TimeBeforeVisibleRange=(Min=1.000000,Max=1.000000)
        TimeBetweenSegmentsRange=(Min=0.010000,Max=0.010000)
        Acceleration=(Z=-500.000000)
        FadeOut=True
        ResetAfterChange=True
        RespawnDeadParticles=False
        InitialParticlesPerSecond=1000.000000
        AutomaticInitialSpawning=False
        Texture=Texture'ETexSFX.water.SFX_Goutte'
        LifetimeRange=(Min=0.250000,Max=0.500000)
        StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=-100.000000,Max=50.000000))
        Name="sprinklerStart"
    End Object
    Emitters(0)=SparkEmitter'EchelonEffect.sprinklerStart'
}
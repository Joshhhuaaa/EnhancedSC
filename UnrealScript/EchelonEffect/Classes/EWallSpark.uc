class EWallSpark extends Emitter;

defaultproperties
{
    Begin Object Class=SparkEmitter Name=WallSpark
        LineSegmentsRange=(Min=1.000000,Max=1.000000)
        TimeBetweenSegmentsRange=(Min=0.040000,Max=0.040000)
        Acceleration=(Z=-100.000000)
        MaxParticles=20
        RespawnDeadParticles=False
        StartSizeRange=(X=(Min=1000.000000,Max=1000.000000))
        Texture=Texture'ETexSFX.Fire.SFX_spark'
        LifetimeRange=(Min=0.300000,Max=0.300000)
        StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-100.000000,Max=100.000000))
        Name="WallSpark"
    End Object
    Emitters(0)=SparkEmitter'EchelonEffect.WallSpark'
}
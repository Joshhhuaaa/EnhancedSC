class EWaterSplashInfiltration extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=Splash0
        ProjectionNormal=(Z=0.000000)
        Acceleration=(Z=-250.000000)
        CollisionSoundProbability=20.000000
        FadeOutStartTime=-2.000000
        FadeOut=True
        MaxParticles=5
        RespawnDeadParticles=False
        StartLocationRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=2.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=15.000000)
        StartSizeRange=(X=(Min=10.000000,Max=20.000000),Y=(Min=20.000000,Max=40.000000),Z=(Min=20.000000,Max=40.000000))
        UniformSize=True
        InitialParticlesPerSecond=80.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'7_1_1_subtex.Exterior.ACC_water01'
        StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=100.000000,Max=200.000000))
        Name="Splash0"
    End Object
    Emitters(0)=SpriteEmitter'EchelonEffect.Splash0'
    Begin Object Class=SpriteEmitter Name=Splash1
        ProjectionNormal=(Z=0.000000)
        Acceleration=(Z=-250.000000)
        CollisionSoundProbability=20.000000
        FadeOutStartTime=-2.000000
        FadeOut=True
        RespawnDeadParticles=False
        StartLocationRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=2.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=8.000000)
        StartSizeRange=(X=(Min=10.000000,Max=20.000000),Y=(Min=20.000000,Max=40.000000),Z=(Min=20.000000,Max=40.000000))
        UniformSize=True
        InitialParticlesPerSecond=80.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'7_1_1_subtex.Exterior.ACC_water01'
        InitialDelayRange=(Min=0.300000,Max=0.300000)
        StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=100.000000,Max=400.000000))
        Name="Splash1"
    End Object
    Emitters(1)=SpriteEmitter'EchelonEffect.Splash1'
    Begin Object Class=SpriteEmitter Name=Splash2
        UseDirectionAs=PTDU_Normal
        FadeOutStartTime=0.700000
        FadeOut=True
        MaxParticles=25
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(1)=(RelativeTime=0.100000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=20.000000)
        StartSizeRange=(X=(Min=10.000000,Max=10.000000))
        UniformSize=True
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'7_1_1_subtex.Exterior.ACC_water01'
        StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000))
        Name="Splash2"
    End Object
    Emitters(2)=SpriteEmitter'EchelonEffect.Splash2'
}

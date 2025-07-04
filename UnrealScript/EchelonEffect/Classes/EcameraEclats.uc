class EcameraEclats  extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=cameraEclats
        Acceleration=(Z=-980.000000)
        ResetAfterChange=True
        RespawnDeadParticles=False
        StartLocationRange=(Y=(Min=-25.000000,Max=25.000000))
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.001000,Max=-0.900000))
        SizeScale(0)=(RelativeSize=5.000000)
        SizeScale(1)=(RelativeTime=5.000000,RelativeSize=1.500000)
        SizeScaleRepeats=1.000000
        StartSizeRange=(X=(Max=8.000000))
        UniformSize=True
        InitialParticlesPerSecond=500.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'EGO_Tex.GenTexGO.GO_camera_Parts'
        TextureUSubdivisions=4
        TextureVSubdivisions=3
        UseRandomSubdivision=True
        LifetimeRange=(Min=0.000001,Max=2.000000)
        StartVelocityRange=(X=(Min=-150.000000,Max=150.000000),Y=(Min=-150.000000,Max=150.000000),Z=(Max=400.000000))
        Name="cameraEclats"
    End Object
    Emitters(0)=SpriteEmitter'cameraEclats'
}
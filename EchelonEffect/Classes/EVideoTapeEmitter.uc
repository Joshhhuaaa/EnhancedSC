class EVideoTapeEmitter extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=VideoTapeEmitter
        Acceleration=(Z=-950.000000)
        UseCollision=True
        DampingFactorRange=(X=(Min=0.900000,Max=0.900000),Y=(Min=0.900000,Max=0.900000),Z=(Min=0.500000,Max=0.600000))
        FadeOutStartTime=0.900000
        FadeOut=True
        MaxParticles=20
        ResetAfterChange=True
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
        DampRotation=True
        RotationDampingFactorRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        UseRegularSizeScale=False
        StartSizeRange=(X=(Min=0.500000,Max=4.000000))
        UniformSize=True
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'EGO_Tex.ABA_TexGO.video3_ABA_PARTS'
        TextureUSubdivisions=2
        TextureVSubdivisions=3
        UseSubdivisionScale=True
        UseRandomSubdivision=True
        LifetimeRange=(Min=40.000000,Max=40.000000)
        StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-10.000000,Max=500.000000))
        Name="VideoTapeEmitter"
    End Object
    Emitters(0)=SpriteEmitter'VideoTapeEmitter'
}
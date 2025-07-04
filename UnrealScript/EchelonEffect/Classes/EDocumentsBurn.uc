class EDocumentsBurn extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=DocumentsBurn
        Acceleration=(X=-2.000000,Y=-2.000000,Z=-6.000000)
        FadeOutStartTime=6.000000
        FadeOut=True
        MaxParticles=5
        StartLocationRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-1.000000,Max=1.000000))
        SpinParticles=True
        RotationOffset=(Pitch=1,Yaw=1,Roll=1)
        SpinsPerSecondRange=(X=(Min=-0.001000,Max=-0.100000))
        RotationDampingFactorRange=(X=(Min=-0.001000,Max=-1.000000))
        StartSizeRange=(X=(Min=2.000000,Max=25.000000))
        UniformSize=True
        InitialParticlesPerSecond=20.000000
        AutomaticInitialSpawning=False
        Texture=Texture'ETexSFX.Paper.SFX_Page_Burn2'
        TextureUSubdivisions=2
        TextureVSubdivisions=3
        BlendBetweenSubdivisions=True
        LifetimeRange=(Min=2.000000,Max=6.000000)
        StartVelocityRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=10.000000,Max=30.000000))
        VelocityLossRange=(Z=(Max=-1.000000))
        Name="DocumentsBurn"
    End Object
    Emitters(0)=SpriteEmitter'DocumentsBurn'
}
class EVase extends Emitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=Vase
        Acceleration=(Z=-950.000000)
        UseCollision=True
        DampingFactorRange=(X=(Min=1.000000),Y=(Min=1.000000),Z=(Min=0.500000,Max=0.500000))
        UseColorScale=True
        ColorScale(0)=(Color=(B=32,G=32,R=64,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=32,G=32,R=64,A=255))
        FadeOutStartTime=0.900000
        FadeOut=True
        MaxParticles=15
        ResetAfterChange=True
        RespawnDeadParticles=False
        StartLocationRange=(Z=(Min=10.000000,Max=50.000000))
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
        DampRotation=True
        RotationDampingFactorRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        UseRegularSizeScale=False
        StartSizeRange=(X=(Min=0.100000,Max=7.000000))
        UniformSize=True
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'EGO_Tex.GenTexGO.GO_vase02_chi'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseSubdivisionScale=True
        UseRandomSubdivision=True
        LifetimeRange=(Max=20.000000)
        StartVelocityRange=(X=(Min=-400.000000,Max=400.000000),Y=(Min=-400.000000,Max=400.000000),Z=(Max=700.000000))
        Name="Vase"
    End Object
    Emitters(0)=SpriteEmitter'Vase'
}
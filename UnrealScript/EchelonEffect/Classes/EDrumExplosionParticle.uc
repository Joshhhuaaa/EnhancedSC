class EDrumExplosionParticle extends Emitter;

#exec OBJ LOAD FILE=..\Sounds\DestroyableObjet.uax

function PostBeginPlay()
{
	Super.PostBeginPlay();

	PlaySound(Sound'DestroyableObjet.Play_BarrilExplosion', SLOT_SFX);
}

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter12
        Acceleration=(Z=3000.000000)
        FadeOutStartTime=0.990000
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.200000,Max=0.200000))
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=0.600000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.300000)
        StartSizeRange=(X=(Min=300.000000,Max=300.000000),Y=(Min=300.000000,Max=300.000000),Z=(Min=300.000000,Max=300.000000))
        UniformSize=True
        InitialParticlesPerSecond=25.000000
        AutomaticInitialSpawning=False
        Texture=Texture'ETexSFX.Fire.ExplodeDoors'
        ThermalVisionFallbackDrawStyle=PTDS_AlphaBlend
        ThermalVisionFallbackTexture=Texture'ETexSFX.Fire.ExplodeDoors_TV'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        BlendBetweenSubdivisions=True
        LifetimeRange=(Min=1.200000,Max=1.200000)
        StartVelocityRange=(X=(Min=-6000.000000,Max=6000.000000),Y=(Min=-6000.000000,Max=6000.000000),Z=(Max=6000.000000))
        VelocityLossRange=(X=(Min=15.000000,Max=20.000000),Y=(Min=15.000000,Max=20.000000),Z=(Min=10.000000,Max=20.000000))
        Name="SpriteEmitter12"
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter12'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseColorScale=True
        ColorScale(0)=(RelativeTime=0.000010,Color=(B=153,G=255,R=255))
        ColorScale(1)=(Color=(B=1,G=1,R=1))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=1,G=1,R=1))
        FadeOutStartTime=0.500000
        FadeOut=True
        FadeInEndTime=0.500000
        FadeIn=True
        RespawnDeadParticles=False
        StartLocationRange=(X=(Min=-30.000000,Max=30.000000),Y=(Min=-30.000000,Max=30.000000),Z=(Min=100.000000,Max=400.000000))
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000),Y=(Min=-0.100000,Max=0.100000),Z=(Min=-0.100000,Max=0.100000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.600000)
        SizeScale(1)=(RelativeTime=0.100000,RelativeSize=1.300000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=200.000000,Max=200.000000),Y=(Min=200.000000,Max=200.000000),Z=(Min=200.000000,Max=200.000000))
        UniformSize=True
        InitialParticlesPerSecond=1000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.smoke.SFX_expsmoke'
        LifetimeRange=(Min=10.000000,Max=10.000000)
        StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Max=100.000000))
        VelocityLossRange=(X=(Min=0.020000,Max=0.020000),Y=(Min=0.020000,Max=0.020000))
        Name="SpriteEmitter1"
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'
    SoundRadiusSaturation=1000.000000
}
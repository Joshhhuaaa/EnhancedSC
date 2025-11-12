class EFlareParticle extends Emitter;

#exec OBJ LOAD FILE=..\Sounds\FisherEquipement.uax

function PostBeginPlay()
{
	Super.PostBeginPlay();
	Disable('Tick');
}

function SetLifeTime(float l)
{
	SetTimer(l,false);
	if (Level.Game.PlayerC.ShadowMode == 0)
	{
		LightEffect = LE_None;
	}
}

function Timer()
{
	Owner.EndEvent();
	Enable('Tick');
}

function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);
	LightBrightness = 255 * Emitters[0].LivingParticles / Emitters[0].MaxParticles;
}

defaultproperties
{
    Begin Object Class=SparkEmitter Name=SparkEmitter8
        LineSegmentsRange=(Min=1.000000,Max=1.000000)
        TimeBetweenSegmentsRange=(Min=0.050000,Max=0.010000)
        Acceleration=(Z=-300.000000)
        FadeOutStartTime=0.900000
        FadeOut=True
        MaxParticles=25
        StartLocationRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000))
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=1000.000000,Max=1000.000000))
        InitialParticlesPerSecond=1.000000
        Texture=Texture'ETexSFX.Fire.SFX_spark02'
        LifetimeRange=(Min=0.070000,Max=0.000010)
        StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=600.000000,Max=600.000000))
        GlowScale=(B=127,G=127,R=127,A=127)
        IsGlowing=True
        Name="SparkEmitter8"
    End Object
    Emitters(0)=SparkEmitter'EchelonEffect.SparkEmitter8'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        Acceleration=(Z=100.000000)
        DampingFactorRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000))
        UseColorScale=True
        ColorScale(0)=(Color=(B=214,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.500000
        FadeOut=True
        FadeInEndTime=0.100000
        FadeIn=True
        StartLocationOffset=(Z=20.000000)
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
        StartSizeRange=(X=(Min=20.000000,Max=20.000000))
        UniformSize=True
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.smoke.SFX_expsmoke'
        LifetimeRange=(Min=2.000000,Max=2.000000)
        StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=50.000000,Max=100.000000))
        GlowScale=(B=127,G=127,R=127,A=127)
        Name="SpriteEmitter0"
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter0'
    bDynamicLight=true
    bTrailerSameRotation=true
    bTrailerPrePivot=true
    Physics=PHYS_Trailer
    LightType=LT_SubtlePulse
    LightEffect=LE_EOmniAtten
    LightBrightness=255
    LightHue=31
    LightRadius=15
    MinDistance=0.000000
    MaxDistance=200.000000
    TrailerOffset=(X=0.000000,Y=0.000000,Z=11.000000)
}
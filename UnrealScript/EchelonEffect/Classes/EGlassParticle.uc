class EGlassParticle extends Emitter
	notplaceable;

//------------------------------------------------------------------------
// Description		
//		Special treatment, since the mesh may vary, calculate size to spawn
//		particle in a real manner
//------------------------------------------------------------------------
function PostBeginPlay()
{
	local Vector min, max, box, local_velocity;

	// Find glass size, inform particle to create real effect
	Owner.GetBoundingBox(min, max);
	Emitters[0].StartLocationRange.X.Min = min.X;
	Emitters[0].StartLocationRange.X.Max = max.X;
	Emitters[0].StartLocationRange.Z.Min = min.Z;
	Emitters[0].StartLocationRange.Z.Max = max.Z;

	// Max particles depending on glass surface
	box = max - min;
	Emitters[0].MaxParticles = Clamp(sqrt(((box.X * box.Z) / 3)), 25, 125);

	Emitters[0].Initialized	= false;

	// Velocity from explosion
	if (Owner.Velocity != Vect(0,0,0))
	{
		local_velocity = ToLocalDir(Owner.Velocity);// / 10.f;
		Emitters[0].StartVelocityRange.X.Max = local_velocity.X;
		Emitters[0].StartVelocityRange.Y.Max = local_velocity.Y;
	}

	Super.PostBeginPlay();
}

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=BreakableGlass
        Acceleration=(Z=-950.000000)
        UseCollision=True
        DampingFactorRange=(X=(Min=0.100000,Max=0.500000),Y=(Min=0.100000,Max=0.500000),Z=(Min=0.200000,Max=0.400000))
        ModulateColorByLighting=True
        LightingAttenuationFactor=0.500000
        FadeOutStartTime=1.000000
        FadeOut=True
        MaxParticles=1
        ResetAfterChange=True
        RespawnDeadParticles=False
        StartLocationRange=(X=(Min=-100.000000,Max=100.000000),Z=(Min=-50.000000,Max=50.000000))
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
        DampRotation=True
        RotationDampingFactorRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        UseRegularSizeScale=False
        StartSizeRange=(X=(Min=0.500000,Max=9.000000))
        UniformSize=True
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ETexSFX.Window.SFX_BGlass'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseSubdivisionScale=True
        UseRandomSubdivision=True
        LifetimeRange=(Min=3.000000,Max=8.000000)
        StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-100.000000))
        VelocityLossRange=(X=(Max=1.000000))
        Name="BreakableGlass"
    End Object
    Emitters(0)=SpriteEmitter'BreakableGlass'
    bUnlit=False
}
class ELiquidContainer extends EGameplayObject;

struct SpillInfo
{
	var Emitter	Spill;
	var float	Level;
	var bool	IsDying;
};

var array<SpillInfo>		Spills;				// Array of all spills
var array<Emitter>			LiquidFlasks;		// Array of all liquid flask
var array<EVolumeTrigger>	Volumes;

var()	class<Emitter>		SpillEmitterClass,
							FlaskEmitterClass,
							HitEffectClass;
var()	Texture				SpillTexture,
							FlaskTexture;
var()	bool				IsFlammable;

var		float				LiquidLevel;		// Current liquid level in object
var		float				LiquidLevelPct;		// Current liquid level in percent
var		float				LiquidDrainSpeed;

var(FootPrint) int			iDirtynessFactor;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	LiquidLevelPct = LiquidLevel / 100.f;
}

//------------------------------------------------------------------------
// Description
//		Treatment when a volume informs me its hit
//------------------------------------------------------------------------
function ProcessFlaskTrigger(Pawn EventInstigator);

//------------------------------------------------------------------------
// Description
//		Calculate hit level in percent on whole object hit surface
//------------------------------------------------------------------------
function float GetHitLevel(vector hit_location)
{
	local float hit_level, box_height, box_zero_level;
	local vector min, max;

	GetBoundingBox(min, max);
	box_height = max.Z - min.Z;
	box_zero_level = location.Z + min.Z;

	hit_level = (hit_location.Z - box_zero_level) / box_height;

	//Log("Location["$Location$"] min["$min$"] max["$max$"] h["$box_height$"] 0["$box_zero_level$"] hit_level["$hit_level$"]");

	return hit_level;
}

function Destructed()
{
	local int i,j;

	//Log(self$" LC Destructed "$Spills.Length);

	Disable('LostChild');

	// Kill all spills
	for (i = 0; i < Spills.Length; i++)
	{
		//Log("0 explicitely destroying"@Spills[i].Spill@Spills[i].Spill.Owner);
		Spills[i].Spill.PlaySound(Sound'Water.Stop_barrilFuelLeak', SLOT_SFX);
		Spills[i].Spill.Destroy();
	}
	Spills.Remove(0,Spills.Length);

	// make liquid disappear
	for (i = 0; i < LiquidFlasks.Length; i++)
	{
		Spawn(class'ESmallFire', self,, LiquidFlasks[i].Location);

		LiquidFlasks[i].Emitters[0].FadeOut = true;
		LiquidFlasks[i].Emitters[0].FadeOutFactor.X = 1.0;
		LiquidFlasks[i].Emitters[0].FadeOutFactor.Y = 1.0;
		LiquidFlasks[i].Emitters[0].FadeOutFactor.Z = 1.0;
		LiquidFlasks[i].Emitters[0].FadeOutFactor.W = 1.0;
		LiquidFlasks[i].Emitters[0].FadeOutStartTime = 0.0;
		LiquidFlasks[i].Emitters[0].LifetimeRange.Min = 3.0;
		LiquidFlasks[i].Emitters[0].LifetimeRange.Max = 3.0;

		for (j = 0; j < LiquidFlasks[i].Emitters[0].Particles.Length; j++)
		{
			LiquidFlasks[i].Emitters[0].Particles[j].MaxLifetime = 3;
			LiquidFlasks[i].Emitters[0].Particles[j].Time = 0;
		}
	}

	Super.Destructed();
}

function Destroyed()
{
	local int i;
	for (i = 0; i < Volumes.Length; i++)
		Volumes[i].Destroy();
	Volumes.Remove(0,Volumes.Length);

	Super.Destroyed();
}

//------------------------------------------------------------------------
// Initial state
//------------------------------------------------------------------------
auto state s_Normal
{
	function BeginState()
	{
		Disable('Tick');
	}

	function Trigger(Actor Other, Pawn EventInstigator, optional name InTag)
	{
		Super.Trigger(Other, EventInstigator, InTag);

		if (!Other.IsA('EVolumeTrigger'))
			return;

		ProcessFlaskTrigger(EventInstigator);
	}

	function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector HitNormal, vector Momentum,
						 class<DamageType> DamageType, optional int PillTag)
	{
		local Rotator			LiquidRotation;
		local Vector			liquid_dir, traceNormal, traceHit, traceEnd;
		local float				HitLevel;
		local EVolumeTrigger	FlaskVolume;
		local Actor				hitActor;

		//log(self$" LC takes damage"@damage@DamageType);

		// If damage comes from an explosion, destroy me!
		// If damage comes from an Npc .. destroy me!
		if ((DamageType == class'Crushed' || DamageType == class'EBurned') ||
			(DamageType == None && EventInstigator != None && !EventInstigator.Controller.bIsPlayer))
		{
			// set for damage call
			Instigator = EventInstigator;

			DelayToDestruction = 2.5f * FRand();
			return;
		}
		else if (DamageType == None)
		{
			// Check hit z to prevent a spill if no liquid at this level
			HitLevel = GetHitLevel(HitLocation);
			if (HitLevel <= LiquidLevelPct)
			{
				//Log("Adding a spill at drum "$HitLevel$"% and drum current "$LiquidLevel$"%");

				// Find spill rotation with Liquiddrum center
				liquid_dir = Normal(HitNormal);
				liquid_dir.Z = 0;
				LiquidRotation = Rotator(liquid_dir);

				// Spawn spill
				Spills.Length = Spills.Length + 1;
				Spills[Spills.Length - 1].Spill = spawn(SpillEmitterClass, self,, HitLocation, LiquidRotation);
				Spills[Spills.Length - 1].Level = HitLevel;
				// If a texture has been specified, change it
				if (SpillTexture != None)
					Spills[Spills.Length - 1].Spill.Emitters[0].Texture = SpillTexture;

				// Find flask location and spawn it
				if (FlaskEmitterClass != None)
				{
					LiquidRotation.Pitch -= 9000;
					traceEnd = HitLocation + (Vect(500,0,0) >> LiquidRotation);
					hitActor = Trace(traceHit, traceNormal, traceEnd, HitLocation, true);
					if (hitActor == None)
						Log("ERROR : Liquid container could not find a spot for the flask."@vsize(traceEnd - HitLocation));

					// be sure to put flask on level geometry
					if (hitActor.bWorldGeometry && traceNormal == Vect(0,0,1))
					{
						//Log("traceNormal"@traceNormal@" hitactor"@hitActor);

						LiquidFlasks.Length = LiquidFlasks.Length + 1;
						LiquidFlasks[LiquidFlasks.Length - 1] = spawn(FlaskEmitterClass, self,, traceHit + traceNormal);
						// If a texture has been specified, change it
						if (FlaskTexture != None)
							LiquidFlasks[LiquidFlasks.Length - 1].Emitters[0].Texture = FlaskTexture;

						FlaskVolume = spawn(class'EVolumeTrigger', self,, traceHit + traceNormal);
						FlaskVolume.TriggerType	 = TT_Shoot;
						FlaskVolume.bHidden		 = false;
						FlaskVolume.bLiquid		 = true;
						FlaskVolume.bFlammable	 = IsFlammable;
						FlaskVolume.bBlockBullet = true;
						FlaskVolume.iDirtynessFactor = iDirtynessFactor;
						FlaskVolume.SetDrawType(DT_None);
						FlaskVolume.SetCollisionSize(50, 10);

						Volumes[Volumes.Length] = FlaskVolume;
					}
				}

				// Enable liquid management
				Enable('Tick');

				// EGameplayObject takedamage not called from here ... so add this one manually
				Instigator = EventInstigator;
				Level.AddChange(self, CHANGE_BrokenObject);
			}
		}

		if (DamageType == None || DamageType == class'EKnocked')
		{
			if (HitSound.Length > 0)
				PlaySound(HitSound[0], SLOT_SFX);

			if (HitEffectClass != None)
				Spawn(HitEffectClass,,,HitLocation - Normal(HitLocation - Location));
		}

		// Always send TakeDamage event for go msg
		if (!bDamageable)
			Damage = 0;
		Super.TakeDamage(Damage, EventInstigator, HitLocation, HitNormal, Momentum, DamageType);
	}

	function Tick(float DeltaTime)
	{
		local int	i;

		// Every seconds, the liquid is drained out for every hole in the container
		LiquidLevel -= DeltaTime * Spills.Length * LiquidDrainSpeed;
		LiquidLevelPct = LiquidLevel / 100.f;

		// Destroy spills under liquid level
		for (i = 0; i < Spills.Length; i++)
		{
			if (!Spills[i].IsDying && Spills[i].Level > LiquidLevelPct)
			{
				Spills[i].IsDying = true;
				Spills[i].Spill.GotoState('s_DyingSpill');

				//Log("Spill["$i$"] dying at level="$Spills[i].Level$" and liquid="$LiquidLevel);

				break;
			}
		}
		//Log("LiquidLevel"@LiquidLevel);
	}

	event LostChild(Actor Other)
	{
		local int i;
		//Log(self@" LC lost child"@Other);
		for (i = 0; i < Spills.Length; i++)
		{
			if (Spills[i].Spill == Other && Spills[i].IsDying)
			{
				//Log("In LostChild Spill["$i$"] destroyed "$Spills[i].IsDying);
				Spills.Remove(i,1);
				return;
			}
		}
	}
}

defaultproperties
{
    SpillEmitterClass=Class'EchelonEffect.ELiquidSpillEmitter'
    LiquidLevel=100.000000
    LiquidDrainSpeed=5.000000
}
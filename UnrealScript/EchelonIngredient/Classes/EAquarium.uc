class EAquarium extends EGameplayObject;

struct EmWat
{
	var()	Emitter WEmitter;
	var		range	InitialLifeTimeRange;
};

var() Mover				Water;
var() EAquariumGlass	Glass;
var() array<Actor>		WaterAnimals;
var() array<EmWat>		WaterEmitters;
var() EVolume			WaterVolume;
var() Actor				WaterEffectLight;

function PostBeginPlay()
{
	local int i;
	
	if (Glass == None)
		Log("WARNING: No Glass for aquarium");
	else
	{
		Glass.SetOwner(self);
	}
		
	// Set water
	if (Water == None)
		Log("WARNING: No Water for aquarium");
	else 
	{
		if (Water.InitialState != 'TriggerControl')
			Log("WARNING: Water for aquarium is not in TriggerControl state");

		Water.SetCollision(false);
		Water.SetOwner(self);
		Water.SavedTrigger = self;
		Water.InitialState		= 'TriggerControl';
		Water.MoverEncroachType	= ME_IgnoreWhenEncroach;
	}
	
	// Volume
	if (WaterVolume == None)
		Log("WARNING: No WaterVolume for aquarium");
	else
	{
		WaterVolume.bLiquid = true;
		WaterVolume.SetCollision(false);
	}

	// Set fish to follow water level
	for (i = 0; i < WaterAnimals.Length; i++)
	{
		WaterAnimals[i].SetOwner(self);
		WaterAnimals[i].SetBase(Water);
	}

	// Set emitters
	for (i = 0; i < WaterEmitters.Length; i++)
	{
		WaterEmitters[i].InitialLifeTimeRange = WaterEmitters[i].WEmitter.Emitters[0].LifeTimeRange;
	}

	Super.PostBeginPlay();
}

function ReceiveMessage(EGameplayObject Sender, EGOMsgEvent Event)
{
	local int i;
	Super.ReceiveMessage(Sender, Event);

	switch (Sender)
	{
	// Glass
	case Glass:
		
		if (Event == GOEV_TakeDamage)
		{
			// dont move if not a real hit
			if (Glass.hit_level == -1)
				break;

			// dont move water if hit is higher than water level.
			if (Glass.hit_level * 100 > Glass.LiquidLevel)
				break;

			Water.KeyPos[1] = Water.KeyPos[0];
			Water.KeyPos[1].Z = Glass.Hit_Z - Water.Location.Z;
			//Water.MoveTime *= 1 - Glass.hit_level;
			Water.MoveTime = 30 * (1 - Glass.hit_level);

			//Log("Water.Location"@Water.Location@"Water.BasePos"@Water.BasePos);
			//Log("Water.KeyPos[0]"@Water.KeyPos[0]@"Water.KeyPos[1]"@Water.KeyPos[1]);
			//Log("Water.PrevKeyNum"@Water.PrevKeyNum@"Water.KeyNum"@Water.KeyNum);

			Enable('Tick');

			Water.Trigger(self, None);
		}
		else if (Event == GOEV_Destructed)
		{
			Disable('Tick');

			Water.bHidden = true;
			Water.SetCollision(false);
			
			// Removed water effect
			if (WaterEffectLight != None)
				WaterEffectLight.SpotProjectedMaterial = WaterEffectLight.default.SpotProjectedMaterial;

			// Make fish desperate
			for (i = 0; i < WaterAnimals.Length; i++)
				WaterAnimals[i].GotoState('s_Flying');

			for (i = 0; i < WaterEmitters.Length; i++)
				WaterEmitters[i].WEmitter.Destroy();
			WaterEmitters.Remove(0,WaterEmitters.Length);

			if (WaterVolume != None)
				WaterVolume.SetCollision(true);
		}

		break;
	}
}

auto state s_Aquarium
{
	function Tick(float DeltaTime)
	{
		local int i;
		local float ratio;

		if (Water == None || !Water.bOpening)
			return;

		ratio = Glass.LiquidLevel / Glass.default.LiquidLevel;
		if (ratio >= 1) // should not happen .. see the break when hitLevel < hit_level
			return;

		for (i = 0; i < WaterEmitters.Length; i++)
		{
			WaterEmitters[i].WEmitter.Emitters[0].LifeTimeRange.Min = WaterEmitters[i].InitialLifeTimeRange.Min * ratio;
			WaterEmitters[i].WEmitter.Emitters[0].LifeTimeRange.Max = WaterEmitters[i].InitialLifeTimeRange.Max * ratio;
		}

		// Remove big water wave if water level is below 35%
		if (ratio < 0.35f && Glass.SpawnableObjects.Length > 2)
		{
			Glass.SpawnableObjects.Remove(0,1);

			if (WaterEffectLight != None)
				WaterEffectLight.SpotProjectedMaterial = WaterEffectLight.default.SpotProjectedMaterial;
		}
	}

Begin:
	Disable('Tick');
}

defaultproperties
{
    bDamageable=false
    StaticMesh=StaticMesh'EGO_OBJ.Langley_ObjGO.GO_aquarium'
    CollisionRadius=64.000000
    CollisionHeight=32.000000
    bStaticMeshCylColl=false
    bBlockPlayers=true
}
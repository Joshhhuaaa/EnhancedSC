class EWallHit extends Actor;

#exec OBJ LOAD FILE=..\textures\ETexSFX.utx 

var() float RicochetNoiseRadius;

var Sound SndBullet;

var Material hitMaterial;

var Texture clampTexture;

var Actor HitActor;  // what was hit

function Noise()
{
    local EDoorMover oDoor;
    local Vector     vSecSndPos;
    local Vector     vInitPos;

	// Noise for NPCs
    if(hitMaterial != None)
    {
        // MClarke: August 8th 2002
        // Drown based on surface type 
        if((hitMaterial.SurfaceType == SURFACE_ConcreteHard)        // Resonating
         ||(hitMaterial.SurfaceType == SURFACE_WoodHard)
         ||(hitMaterial.SurfaceType == SURFACE_WoodBoomy)
         ||(hitMaterial.SurfaceType == SURFACE_WaterPuddle)
         ||(hitMaterial.SurfaceType == SURFACE_MetalHard)
         ||(hitMaterial.SurfaceType == SURFACE_MetalReverb)
         ||(hitMaterial.SurfaceType == SURFACE_MetalSheet)
         ||(hitMaterial.SurfaceType == SURFACE_BreakingGlass)
         ||(hitMaterial.SurfaceType == SURFACE_FenceMetal))
        {
            MakeNoise(RicochetNoiseRadius, NOISE_Ricochet);  
        }        
        else if((hitMaterial.SurfaceType == SURFACE_Grass)          // Absorbing
              ||(hitMaterial.SurfaceType == SURFACE_ConcreteDirt)
              ||(hitMaterial.SurfaceType == SURFACE_Carpet)
              ||(hitMaterial.SurfaceType == SURFACE_SnowPowder)
              ||(hitMaterial.SurfaceType == SURFACE_Snow)
              ||(hitMaterial.SurfaceType == SURFACE_DeepWater)
              ||(hitMaterial.SurfaceType == SURFACE_MediumWater)
              ||(hitMaterial.SurfaceType == SURFACE_Sand)
              ||(hitMaterial.SurfaceType == SURFACE_Bush)
              ||(hitMaterial.SurfaceType == SURFACE_FenceVine))    
        {
            MakeNoise(RicochetNoiseRadius - 700.f, NOISE_Ricochet);  
        }
        else                                                        // Normal
        {
            MakeNoise(RicochetNoiseRadius - 400.f, NOISE_Ricochet);  
        }
    }
    else
    {
	    MakeNoise(RicochetNoiseRadius, NOISE_Ricochet);    
    }

    if((HitActor != None) && (HitActor.bIsMover))
    {
        oDoor = EDoorMover(HitActor);

        if((oDoor != None) && (oDoor.bPropagatesSound))
        {
            oDoor.PropagateSound(self);
        }
    }
}

function Emit()
{
	local class<Emitter> sparkEmitter;
	local int i;
	local int slice;
	local vector x, y, z;
	local Material currentMtl;

	currentMtl=hitMaterial;
	while(Modifier(currentMtl) != none)
	{
		currentMtl=Modifier(currentMtl).Material;
	}

	hitMaterial = currentMtl;

    // Sound for player
	if (hitMaterial != None && hitMaterial.SurfaceType == SURFACE_BreakingGlass)
		AddSoundRequest(Sound'GunCommon.Play_Random_BulletHitGlass', SLOT_SFX, 0.05f);
	else
		AddSoundRequest(SndBullet, SLOT_SFX, 0.05f);

	//***********************************************
	//* SPARK ***************************************
	//***********************************************
	sparkEmitter=class'EWallSpark';
	if ( currentMtl != none )
	{
		for(i=0; i<Level.ImpactSurfaceToEmitterLink.Length; i++)
		{
			if ( currentMtl.SurfaceType == Level.ImpactSurfaceToEmitterLink[i].surfType )
			{
				sparkEmitter=Level.ImpactSurfaceToEmitterLink[i].emitterClass;
				break;
			}
		}
	}
	if (sparkEmitter != none)
		Spawn(sparkEmitter, self);

	//***********************************************
	//* DECAL ***************************************
	//***********************************************
	if (currentMtl != none && Level.pProjTexture != none)
	{
		for(i=0; i<Level.ImpactSurfaceToSubTexLink.Length; i++)
		{
			if ( currentMtl.SurfaceType == Level.ImpactSurfaceToSubTexLink[i].surfType )
			{
				break;
			}
		}

		if (i!=Level.ImpactSurfaceToSubTexLink.Length)
		{
			GetAxes(Rotation, x, y, z);			
			Level.AddImpact(Location, OrthoRotation(-x, -y, -z), false, false, i);
		}
	}
}

defaultproperties
{
    RicochetNoiseRadius=1500.000000
    clampTexture=Texture'ETexSFX.WallImpact.DecalClamp'
    bHidden=true
    LifeSpan=3.000000
    SoundRadiusSaturation=300.000000
}
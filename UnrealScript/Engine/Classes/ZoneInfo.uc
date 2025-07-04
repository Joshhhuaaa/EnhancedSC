//=============================================================================
// ZoneInfo, the built-in Unreal class for defining properties
// of zones.  If you place one ZoneInfo actor in a
// zone you have partioned, the ZoneInfo defines the 
// properties of the zone.
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class ZoneInfo extends Info
	native
	placeable;

#exec Texture Import File=Textures\ZoneInfo.pcx Name=S_ZoneInfo Mips=Off MASKED=1 NOCONSOLE

//-----------------------------------------------------------------------------
// Zone properties.

var skyzoneinfo SkyZone; // Optional sky zone containing this zone's sky.
var() name ZoneTag;

//-----------------------------------------------------------------------------
// Zone flags.

var() const bool   bFogZone;     // Zone is fog-filled.
var()		bool   bTerrainZone;	// There is terrain in this zone.
var()		bool   bDistanceFog;	// There is distance fog in this zone.
// ***********************************************************************************************
// * BEGIN UBI MODIF 
// * dchabot (12 nov. 2001)
// ***********************************************************************************************
var(Sound)  bool PlayFightMusic;
var(Sound)  bool PlayStressMusic;
var(Sound)  bool PlayFisherMusic;
var()		bool	bFlashlightZone;	// NPCs should use flashlights when in this zone
var(Camera)	EVolumeSize VolumeSize;
var() array<Actor>				CustomEchelonLightExclusion;
// ***********************************************************************************************
// * END UBI MODIF 
// * dchabot (12 nov. 2001)
// ***********************************************************************************************

var const array<TerrainInfo> Terrains;
var const array<EOceanInfo>  Oceans;

//-----------------------------------------------------------------------------
// Zone light.

var(ZoneLight) byte AmbientBrightness, AmbientHue, AmbientSaturation;

var(ZoneLight) color DistanceFogColor;
var(ZoneLight) float DistanceFogStart;
var(ZoneLight) float DistanceFogEnd;

var(ZoneLight) const texture EnvironmentMap;
var(ZoneLight) float TexUPanSpeed, TexVPanSpeed;

var(Sound) array<Sound> m_EnterSounds;
var(Sound) array<Sound> m_ExitSounds;
var(Sound) ESoundSlot Sound_type;
var(Sound) bool InteriorZone;
var(Sound) bool PlayExplorationMusic;
var(Sound) bool UseReverb;
var(Ocean)	bool hideOcean;
var(Sound) int ReverbEffect;

var(AI)	   array<ZoneInfo> ForcedHearingZones;

//=============================================================================
// Iterator functions.

// Iterate through all actors in this zone.
native(308) final iterator function ZoneActors( class<actor> BaseClass, out actor Actor );

function LinkToSkybox()
{
	local skyzoneinfo TempSkyZone;

	// SkyZone.
	foreach AllActors( class 'SkyZoneInfo', TempSkyZone, '' )
		SkyZone = TempSkyZone;
	foreach AllActors( class 'SkyZoneInfo', TempSkyZone, '' )
		if( TempSkyZone.bHighDetail == Level.bHighDetailMode )
			SkyZone = TempSkyZone;
}

//=============================================================================
// Engine notification functions.

function PreBeginPlay()
{
	Super.PreBeginPlay();

	// call overridable function to link this ZoneInfo actor to a skybox
	LinkToSkybox();
}

// When an actor enters this zone.
event ActorEntered( actor Other )
{
    local INT iSoundNb;

	if ( Other.bIsPawn )
		VerifyOcclusion();

	if (Other.bIsPlayerPawn)
	{
		if (UseReverb)
			SetReverbEffect(ReverbEffect);
	}

    if ((Other.bIsPlayerPawn) &&
        (m_EnterSounds.Length != 0))
    {
        for(iSoundNb = 0; iSoundNb < m_EnterSounds.Length; iSoundNb++)
        {
            PlaySound(m_EnterSounds[iSoundNb], Sound_type);
        }
    }

}

// When an actor leaves this zone.
event ActorLeaving( actor Other )
{
    local INT iSoundNb;

    if ((Other.bIsPlayerPawn) &&
        (m_ExitSounds.Length != 0))
    {
        for(iSoundNb = 0; iSoundNb < m_ExitSounds.Length; iSoundNb++)
        {
            PlaySound(m_ExitSounds[iSoundNb], Sound_type);
        }
    }

	if (Other.bIsPlayerPawn)
	{
		if (UseReverb)
			SetReverbEffect(0);
	}
}

defaultproperties
{
    PlayFightMusic=true
    PlayStressMusic=true
    AmbientSaturation=255
    DistanceFogColor=(R=128,G=128,B=128,A=0)
    DistanceFogStart=3000.000000
    DistanceFogEnd=8000.000000
    TexUPanSpeed=1.000000
    TexVPanSpeed=1.000000
    Sound_type=SLOT_Ambient
    InteriorZone=true
    PlayExplorationMusic=true
    bStatic=true
    bNoDelete=true
    Texture=Texture'S_ZoneInfo'
}
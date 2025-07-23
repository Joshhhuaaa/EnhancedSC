class EFn7 extends EHandGun;

#exec OBJ LOAD FILE=..\Sounds\FisherEquipement.uax
/*
// Joshua - Focus mode
var bool bInFocusMode;
var float m_holdMax;
var float m_tiredMax;
var float m_fatigueLevel;
var bool m_isTired;
var float m_focusProgress; // 0.0 = normal accuracy, 1.0 = full focus accuracy
var float m_focusTransitionTime; // How long it takes to reach full focus (in seconds)
var float m_minHoldTime; // Minimum time button must be held before focus kicks in
var float m_currentHoldTime; // How long the button has been held this attempt
*/

function PostBeginPlay()
{
    Super.PostBeginPlay();
    HUDTex       = EchelonLevelInfo(Level).TICON.qi_ic_beretta;
    InventoryTex = EchelonLevelInfo(Level).TICON.inv_ic_beretta;
    ItemName     = "FN7";
	ItemVideoName = "gd_fn702.bik";
    Description  = "FN7Desc";
	HowToUseMe  = "FN7HowToUseMe";
}

function bool SwitchROF()
{
	switch( eROFMode )
	{
		case ROF_Single : eROFMode = ROF_Single; return false;
	}
}

function bool IsROFModeAvailable(ERateOfFireMode rof)
{
    switch( rof )
	{
        case ROF_Single:
            return true;
        default:
            return false;
    }
}
/*
//------------------------------------------------------------------------
// Description		
//		ExitFocusMode - Exit focus mode and return to normal accuracy
//------------------------------------------------------------------------
function ExitFocusMode(EPlayerController EPC)
{
    if( bInFocusMode )
    {
        // Exit focus mode,  return to normal accuracy
        bInFocusMode = false;
        AccuracyMovementModifier = 5.000000;
        AccuracyReturnModifier = 10.000000;
        AccuracyBase = 0.500000;
        
        EPC.m_holdingBreath = false;
        
        EPC.ePawn.PlaySound(Sound'FisherVoice.Stop_Sq_FisherHeartBeat', SLOT_SFX);
        EPC.ePawn.StopSound(Sound'FisherVoice.Play_FisherBreathOut', 0.25f);
        EPC.ePawn.AddSoundRequest(Sound'FisherVoice.Play_FisherBreathIn', SLOT_SFX, 0.25f);
    }
}

// ----------------------------------------------------------------------
// state s_Selected
// ----------------------------------------------------------------------
state s_Selected
{
	function BeginState()
	{
		Super.BeginState();
	}

	function Tick( float DeltaTime )
	{
		local EPlayerController EPC;
		local bool holding;
		  Super.Tick(DeltaTime);
		
		if( Controller != None && Controller.bIsPlayer )
		{
			EPC = EPlayerController(Controller);
					holding = EPC.bAltFire != 0 && !m_isTired;
			
			if( holding )
			{
				m_currentHoldTime += DeltaTime;
				
				if( !bInFocusMode && m_currentHoldTime >= m_minHoldTime )
				{
					// Enter focus mode only after minimum hold time
					bInFocusMode = true;
					m_focusProgress = 0.0; // Start with normal accuracy
					
					EPC.m_holdingBreath = true;
					
					EPC.ePawn.PlaySound(Sound'FisherVoice.Play_FisherBreathOut', SLOT_SFX);
					EPC.ePawn.PlaySound(Sound'FisherVoice.Play_Sq_FisherHeartBeat', SLOT_SFX);
				}
			}
			else
			{
				// Button released - reset hold time and exit focus if active
				m_currentHoldTime = 0.0;
				
				if( bInFocusMode )
				{
					ExitFocusMode(EPC);
				}
			}
			
			if( bInFocusMode )
			{
				// Gradually improve accuracy as we focus
				if( m_focusProgress < 1.0 )
				{
					m_focusProgress += DeltaTime / m_focusTransitionTime;
					if( m_focusProgress > 1.0 )
						m_focusProgress = 1.0;
					
					// Interpolate between normal and focus accuracy values
					AccuracyMovementModifier = 5.000000 - (2.500000 * m_focusProgress); // 5.0 -> 2.5
					AccuracyReturnModifier = 10.000000 + (10.000000 * m_focusProgress); // 10.0 -> 20.0
					AccuracyBase = 0.500000 - (0.250000 * m_focusProgress); // 0.5 -> 0.25
				}
				
				m_fatigueLevel += DeltaTime / m_holdMax;
				
				if( m_fatigueLevel >= 1.0 )
				{
					m_isTired = true;
					ExitFocusMode(EPC);
				}
			}
			else if( m_isTired )
			{
				// Apply accuracy penalty when tired
				AccuracyMovementModifier = 15.000000;
				AccuracyReturnModifier = 5.000000;
				AccuracyBase = 2.000000;
				
				m_fatigueLevel -= DeltaTime / m_tiredMax;
				if( m_fatigueLevel <= 0.0 )
				{
					m_fatigueLevel = 0.0;
					m_isTired = false;
					
					// Restore normal accuracy when no longer tired
					AccuracyMovementModifier = 5.000000;
					AccuracyReturnModifier = 10.000000;
					AccuracyBase = 0.500000;
				}
			}
			else if( m_fatigueLevel > 0.0 )
			{
				// Gradually recover fatigue when not holding breath and not tired
				m_fatigueLevel -= DeltaTime / (m_tiredMax * 0.5);
				if( m_fatigueLevel <= 0.0 )
				{
					m_fatigueLevel = 0.0;
				}
			}
		}
	}
}
 */
// ----------------------------------------------------------------------
// state s_Inventory - Must keep this gun always Visible
// ----------------------------------------------------------------------
state s_Inventory
{
	function BeginState()
	{
		Super.BeginState();
		bHidden	= false;
	}
}

defaultproperties
{
    Ammo=40
    MaxAmmo=60
    ClipAmmo=20
    ClipMaxAmmo=20
    RateOfFire=0.187000
    BaseDamage=100
    FireNoiseRadius=400
    FireSingleShotSound=Sound'FisherEquipement.Play_FisherPistolSingleShot'
    ReloadSound=Sound'FisherEquipement.Play_FNPistolReload'
    EmptySound=Sound'GunCommon.Play_PistolEmpty'
    EjectedClass=Class'EShellCaseSmall'
    EjectedOffset=(X=2.425500,Y=0.763900,Z=7.027100)
    MuzzleOffset=(X=38.911000,Y=0.000000,Z=7.313000)
    MagazineMesh=StaticMesh'EMeshIngredient.weapon.F7MAG'
    MagazineOffset=(X=2.985000,Y=0.000000,Z=5.431000)
    RecoilStrength=1.000000
    RecoilAngle=10.000000
    RecoilStartAlpha=1.000000
    RecoilFadeOut=4.000000
    UseAccuracy=true
    AccuracyMovementModifier=5.000000
    AccuracyReturnModifier=10.000000
	AccuracyBase=0.500000
	//m_holdMax=3.000000
    //m_tiredMax=3.000000
    //m_focusTransitionTime=0.500000
    //m_minHoldTime=0.300000
    ObjectHudClass=Class'EF2000Reticle'
    StaticMesh=StaticMesh'EMeshIngredient.weapon.F7'
    CollisionRadius=6.000000
    CollisionHeight=6.000000
}
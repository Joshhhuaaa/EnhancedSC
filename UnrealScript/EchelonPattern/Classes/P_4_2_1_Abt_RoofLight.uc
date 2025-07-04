//=============================================================================
// P_4_2_1_Abt_RoofLight
//=============================================================================
class P_4_2_1_Abt_RoofLight extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\Machine.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        default:
            break;
        }
    }
}

function InitPattern()
{
    local Pawn P;
    local Actor A;

    Super.InitPattern();

    ForEach AllActors(class'Actor', A)
    {
        if(A.name == 'StaticMeshActor83')
            SoundActors[0] = A;
    }

    if( !bInit )
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Start:
    Log("Start");
    SendPatternEvent('EGroupAI5','RemoveLiveOnes');
	SoundActors[0].PlaySound(Sound'Machine.Play_parkingLightBuzz', SLOT_SFX);
LoopA:
    Log("LoopA");
	SoundActors[0].PlaySound(Sound'Machine.Stop_parkingLightBuzz', SLOT_SFX);
    Sleep(0.5);
    SendUnrealEvent('ELightSwitch0');
    Sleep(2.5);
    CheckFlags(V4_2_1_Abattoir(Level.VarObject).RoofLightPass,TRUE,'SetON');
    Sleep(2.5);
    CheckFlags(V4_2_1_Abattoir(Level.VarObject).RoofLightPass,TRUE,'SetON');
    Sleep(2.5);
    CheckFlags(V4_2_1_Abattoir(Level.VarObject).RoofLightPass,TRUE,'SetON');
    SendUnrealEvent('ELightSwitch0');
	SoundActors[0].PlaySound(Sound'Machine.Play_parkingLightBuzz', SLOT_SFX);
    Sleep(5);
    CheckFlags(V4_2_1_Abattoir(Level.VarObject).RoofLightPass,TRUE,'SetNormalAfterDeath');
    Jump('LoopA');
JumpFin:
    Log("JumpFin");
    End();
SetON:
    Log("SetON");
    SendUnrealEvent('ELightSwitch0');
	SoundActors[0].PlaySound(Sound'Machine.Play_parkingLightBuzz', SLOT_SFX);
    CheckFlags(V4_2_1_Abattoir(Level.VarObject).SpetzOnRoof,TRUE,'JumpFin');
SetNormalAfterDeath:
    Log("SetNormalAfterDeath");
    CheckFlags(V4_2_1_Abattoir(Level.VarObject).RoofLightPass,FALSE,'Start');
    Sleep(4);
    Jump('SetNormalAfterDeath');

}


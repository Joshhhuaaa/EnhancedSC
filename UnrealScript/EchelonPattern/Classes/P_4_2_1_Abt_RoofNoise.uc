//=============================================================================
// P_4_2_1_Abt_RoofNoise
//=============================================================================
class P_4_2_1_Abt_RoofNoise extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_2_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int OkayToTelep;
var int Pass2;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('AntennaSAFEflag');
            break;
        case AI_UNCONSCIOUS:
            EventJump('AntennaSAFEflag');
            break;
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

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'EGeorgianSoldier1')
            Characters[1] = P.controller;
        if (P.name == 'EGeorgianSoldier14')
            Characters[2] = P.controller;
        if (P.name == 'spetsnaz9')
            Characters[3] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if (A.name == 'spetsnaz9')
            SoundActors[0] = A;
    }

    if (!bInit)
    {
    bInit=TRUE;
    OkayToTelep=1;
    Pass2=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
RoofNoise:
    Log("noise of Sam when walking on the roof");
    CheckFlags(Pass2,TRUE,'TimeAfter');
FirstTime:
    Log("First time that Sam walk on the roof");
    SetFlags(Pass2,TRUE);
	SoundActors[0].PlaySound(Sound'S4_2_1Voice.Stop_42_35_01', SLOT_Barks);
    Talk(Sound'S4_2_1Voice.Play_42_07_01', 3, , TRUE, 0);
    Talk(Sound'S4_2_1Voice.Play_42_07_02', 3, , FALSE, 0);
    SendPatternEvent('EGroupAI18','ResetPass1');
    End();
AlarmINstudio:
    Log("");
    DisableMessages(FALSE, TRUE);
    SetExclusivity(TRUE);
    Jump('jumpA');
TimeAfter:
    Log("when Sam make too mucch noise on the roof.");
    DisableMessages(FALSE, TRUE);
	SoundActors[0].PlaySound(Sound'S4_2_1Voice.Stop_42_35_01', SLOT_Barks);
	SoundActors[0].PlaySound(Sound'S4_2_1Voice.Stop_42_07_02', SLOT_Barks);
    Talk(Sound'S4_2_1Voice.Play_42_08_01', 3, , FALSE, 0);
jumpA:
    Log("The two guards are being sent to investigate the antenna, so they will not be teleported later.");
    SetFlags(OkayToTelep,FALSE);
    DisableMessages(FALSE, TRUE);
    SetExclusivity(TRUE);
    SetFlags(V4_2_1_Abattoir(Level.VarObject).RoofLightPass,TRUE);
    SendPatternEvent('AntennaSwitch','DISABLEswitch');
    ResetGoals(1);
    ResetGoals(2);
    ChangeState(1,'s_alert');
    ChangeState(2,'s_alert');
    Goal_Default(1,GOAL_Guard,0,,'EFocusPoint30',,'PathNode228',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_MoveTo,9,,'PLAYER','PLAYER','PathNode41',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Guard,0,,'EFocusPoint20',,'PathNode308',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    SetExclusivity(FALSE);
    End();
JumpFin:
    Log("");
    End();
AntennaSAFEflag:
    Log("checking if its safe to reenable antenna switch");
    CheckIfIsDead(1,'IsDeadBoth');
    CheckIfIsUnconscious(1,'IsDeadBoth');
    End();
IsDeadBoth:
    Log("");
    CheckIfIsDead(2,'FlagAntennaSAFE');
    CheckIfIsUnconscious(2,'FlagAntennaSAFE');
    End();
FlagAntennaSAFE:
    Log("it is safe to reenable antenna switch");
    SendPatternEvent('AntennaSwitch','ENABLEswitch');
    End();
GrinkoTalk:
    Log("GrinkoTalk");
    Talk(Sound'S4_2_1Voice.Play_42_35_01', 3, , TRUE, 0);
    End();
StopTalk:
    Log("");
    End();
	SoundActors[0].PlaySound(Sound'S4_2_1Voice.Stop_42_35_01', SLOT_Barks);
    End();
TeleportSafe:
    Log("The antenna has been switched without Sam being detected first, teleporting out the 2 guards.");
    DisableMessages(TRUE, TRUE);
    SetExclusivity(TRUE);
    CheckFlags(OkayToTelep,FALSE,'DoNothing');
    Teleport(1, 'SoundSafeOutOne');
    Teleport(2, 'SoundSafeOutTwo');
    KillNPC(1, FALSE, TRUE);
    KillNPC(2, FALSE, TRUE);
    DisableMessages(FALSE, FALSE);
    SetExclusivity(FALSE);
    End();
DoNothing:
    Log("Doing nothing");
    End();

}


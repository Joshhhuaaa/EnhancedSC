//=============================================================================
// P_0_0_3_TrainingT3_Retinal04
//=============================================================================
class P_0_0_3_TrainingT3_Retinal04 extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S0_0_3Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int ReachedDoor;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('ManDown');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('OffHeard');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('OffSaw');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('OffSaw');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('OffSaw');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('OffDamage');
            break;
        case AI_UNCONSCIOUS:
            EventJump('CheckIfValid');
            break;
        default:
            break;
        }
    }
}

function InitPattern()
{
    local Pawn P;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'ECIARookie4')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
        }
        if (P.name == 'ELambert0')
            Characters[2] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    ReachedDoor=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Setup:
    Log("Setup - Retinal04");
    ResetNPC(1,FALSE);
    DisableMessages(FALSE, FALSE);
    End();
CheckIfValid:
    Log("CheckIfValid - Retinal04");
    CheckFlags(ReachedDoor,FALSE,'OffDamage');
    End();
Completed:
    Log("Completed - Retinal04");
    SetFlags(ReachedDoor,TRUE);
    GoalCompleted('Retinal04');
    End();
OffHeard:
    Log("Off - Retinal04");
    DisableMessages(TRUE, TRUE);
    PlayerMove(false);
    Talk(Sound'S0_0_3Voice.Play_00_25_09', 1, , TRUE, 0);
    Sleep(3);
    Jump('Failed');
OffSaw:
    Log("");
    DisableMessages(TRUE, TRUE);
    PlayerMove(false);
    Talk(Sound'S0_0_3Voice.Play_00_25_10', 1, , TRUE, 0);
    Sleep(3);
    Jump('Failed');
OffDamage:
    Log("");
    DisableMessages(TRUE, TRUE);
    PlayerMove(false);
    Jump('Failed');
Failed:
    Log("Failed - Retinal04");
    DisableMessages(TRUE, TRUE);
    Sleep(2);
    Speech(Localize("P_0_0_3_TrainingT3_Retinal04", "Speech_0001L", "Localization\\P_0_0_3_Training"), Sound'S0_0_3Voice.Play_00_99_14', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(3);
    Close();
    Sleep(2);
Reset:
    Log("Reset - Retinal04");
    QuickSaveLoad(FALSE, TRUE);
    End();
Disable:
    Log("Disable - Retinal04");
    DisableMessages(TRUE, FALSE);
    End();
ManDown:
    Log("A member has been killed");
    CheckIfIsDead(1,'Murder');
    End();
Murder:
    SendPatternEvent('T3CommsGroup','BloodyMurder');
DoNothing:
    Log("Doing nothing");
    End();

}


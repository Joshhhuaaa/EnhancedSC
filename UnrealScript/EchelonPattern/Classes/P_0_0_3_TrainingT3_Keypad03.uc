//=============================================================================
// P_0_0_3_TrainingT3_Keypad03
//=============================================================================
class P_0_0_3_TrainingT3_Keypad03 extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S0_0_3Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int GotCode;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_HEAR_RICOCHET:
            EventJump('OffHeard');
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
        if(P.name == 'ELambert0')
            Characters[1] = P.controller;
        if(P.name == 'ECIARookie1')
        {
            Characters[2] = P.controller;
            EAIController(Characters[2]).bAllowKnockout = true;
        }
    }

    if( !bInit )
    {
    bInit=TRUE;
    GotCode=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Setup:
    Log("Setup - Keypad03");
    ResetNPC(2,FALSE);
    DisableMessages(FALSE, FALSE);
    End();
CheckIfValid:
    Log("CheckIfValid - Keypad03");
    CheckFlags(GotCode,FALSE,'OffDamage');
    End();
Completed:
    Log("Completed - Keypad03");
    DisableMessages(TRUE, TRUE);
    PlayerMove(false);
    GoalCompleted('Keypad03');
    SendPatternEvent('T3CommsGroup','Retinal04');
    End();
OffHeard:
    Log("Off - Keypad03");
    DisableMessages(TRUE, TRUE);
    PlayerMove(false);
    Talk(Sound'S0_0_3Voice.Play_00_25_09', 2, , TRUE, 0);
    Sleep(3);
    Jump('Failed');
OffSaw:
    Log("");
    PlayerMove(false);
    DisableMessages(TRUE, TRUE);
    Talk(Sound'S0_0_3Voice.Play_00_25_10', 2, , TRUE, 0);
    Sleep(3);
    Jump('Failed');
OffDamage:
    Log("");
    PlayerMove(false);
    DisableMessages(TRUE, TRUE);
    Speech(Localize("P_0_0_3_TrainingT3_Keypad03", "Speech_0005L", "Localization\\P_0_0_3_Training"), Sound'S0_0_3Voice.Play_00_99_14', 1, 0, TR_HEADQUARTER, 0, false);
    Jump('Failed');
Failed:
    Log("Failed - KeyPad03");
    DisableMessages(TRUE, TRUE);
Reset:
    Log("Reset - Keypad03");
    QuickSaveLoad(FALSE, TRUE);
    End();
GotCode:
    Log("Got Code - Keypad03");
    SetFlags(GotCode,TRUE);
End:
    End();
Disable:
    Log("Disable - Keypad03");
    DisableMessages(TRUE, FALSE);
    End();

}


//=============================================================================
// P_0_0_3_TrainingT3_Sound07
//=============================================================================
class P_0_0_3_TrainingT3_Sound07 extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S0_0_3Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int IgnoreSounds;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_HEAR_RICOCHET:
            EventJump('CheckIfValid');
            break;
        case AI_HEAR_SOMETHING:
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
        if (P.name == 'EUSPrisoner0')
            Characters[1] = P.controller;
        if (P.name == 'EUSPrisoner1')
            Characters[2] = P.controller;
        if (P.name == 'EUSPrisoner2')
            Characters[3] = P.controller;
        if (P.name == 'ELambert0')
            Characters[4] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    IgnoreSounds=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Setup:
    Log("Setup - Sound07");
    End();
CheckIfValid:
    Log("CheckIfValid - Sound07");
    CheckFlags(IgnoreSounds,FALSE,'Failed');
    End();
Complete:
    Log("Complete - Sound07");
    DisableMessages(TRUE, TRUE);
    PlayerMove(false);
    SetFlags(IgnoreSounds,TRUE);
    GoalCompleted('Sound07');
    Speech(Localize("P_0_0_3_TrainingT3_Sound07", "Speech_0003L", "Localization\\P_0_0_3_Training"), Sound'S0_0_3Voice.Play_00_29_02', 4, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    PlayerMove(true);
    Teleport(4, 'Lambert07');
    SendPatternEvent('GroupHideBody06','FinaleTeleport');
    DisableMessages(FALSE, FALSE);
    End();
Failed:
    Log("Failed - Sound 07");
    DisableMessages(TRUE, TRUE);
    PlayerMove(false);
    Speech(Localize("P_0_0_3_TrainingT3_Sound07", "Speech_0001L", "Localization\\P_0_0_3_Training"), Sound'S0_0_3Voice.Play_00_29_04', 4, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    Sleep(2);
Reset:
    Log("Reset - Sound07");
    QuickSaveLoad(FALSE, FALSE);
    End();
    Log("if the load works, delete everything between this RED comment tag and the next RED comment tag.");
    PlayerMove(false);
    Sleep(2.5);
    Teleport(0, 'StartSound07');
    Sleep(1.5);
    PlayerMove(true);
    DisableMessages(FALSE, FALSE);
    End();
    Log("if the load works, delete everything between this RED comment tag and the previous RED comment tag.");
WentPastDoor:
    Log("WentPastDoor - Sound07");
    SendPatternEvent('T3CommsGroup','Shooting08');
    End();

}


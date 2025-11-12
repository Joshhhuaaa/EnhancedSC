//=============================================================================
// P_3_3_1_Mine_ColonelEvents
//=============================================================================
class P_3_3_1_Mine_ColonelEvents extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int DoorOpen;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('Death');
            break;
        case AI_UNCONSCIOUS:
            EventJump('Death');
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
        if (P.name == 'EAzeriColonel0')
            Characters[1] = P.controller;
        if (P.name == 'ELambert1')
            Characters[2] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    DoorOpen=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Milestone:
    Log("Milestone");
    CheckFlags(V3_3_1MiningTown(Level.VarObject).InsideHQAlerted,TRUE,'HQNotDoneStealth');
HQDoneStealth:
    Log("HQDoneStealth");
    Goal_Set(1,GOAL_MoveTo,9,,,,'EasySneakColAchtung',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,8,,'UglyTruckPosterAA','UglyTruckPosterAA','EasySneakColAchtung',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
HQNotDoneStealth:
    Log("HQNotDoneStealth");
    Goal_Set(1,GOAL_MoveTo,9,,,,'EAzeriColonel_200',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,8,,,,'EAzeriColonel_200',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
Death:
    Log("Death");
    CheckFlags(DoorOpen,FALSE,'Failure');
    End();
DoorOpened:
    Log("DoorOpened");
    SetFlags(DoorOpen,TRUE);
    End();
Failure:
    Log("Failure");
    SetProfileDeletion();
    Speech(Localize("P_3_3_1_Mine_ColonelEvents", "Speech_0002L", "Localization\\P_3_3_1MiningTown"), None, 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(3);
    Close();
    GameOver(false, 0);
End:
    End();

}

defaultproperties
{
}

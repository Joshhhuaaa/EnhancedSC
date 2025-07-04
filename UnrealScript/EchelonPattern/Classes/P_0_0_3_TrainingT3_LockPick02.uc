//=============================================================================
// P_0_0_3_TrainingT3_LockPick02
//=============================================================================
class P_0_0_3_TrainingT3_LockPick02 extends EPattern;

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

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if(P.name == 'ELambert0')
            Characters[1] = P.controller;
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
Setup:
    Log("Setup - LockPick02");
    LockDoor('Door0203', TRUE, TRUE);
    End();
CheckIfValid:
    Log("CheckIfValid - LockPick02");
    GoalCompleted('LockPick02');
    End();
Completed:
    Log("Completed - LockPick02");
    InventoryManager(0, false, '', 0, true, class 'ELockpick', false);
    PlayerMove(false);
    SendPatternEvent('T3CommsGroup','Keypad03');
    End();
Failed:
    Log("Failed - LockPick02");
Reset:
    Log("Reset - LockPick02");
    Teleport(0, 'StartLockPick02');
    End();

}


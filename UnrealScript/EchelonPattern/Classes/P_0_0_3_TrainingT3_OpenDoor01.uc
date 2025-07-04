//=============================================================================
// P_0_0_3_TrainingT3_OpenDoor01
//=============================================================================
class P_0_0_3_TrainingT3_OpenDoor01 extends EPattern;

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
    Log("Setup - OpenDoor01");
    LockDoor('Door0102', FALSE, TRUE);
    End();
CheckIfValid:
    Log("CheckIfValid - OpenDoor01");
    SendPatternEvent('GroupKeypad03','Disable');
    Jump('Completed');
    End();
Completed:
    Log("Completed - OpenDoor01");
    GoalCompleted('OpenDoor01');
    PlayerMove(false);
    InventoryManager(0, true, '', 1, true, class 'ELockpick', false);
    PlayerMove(true);
    SendPatternEvent('T3CommsGroup','LockPick02');
    End();
Failed:
    Log("Failed - OpenDoor01");
Reset:
    Log("Reset - OpenDoor01");
    Teleport(0, 'RetryDoor');
    Jump('Setup');

}


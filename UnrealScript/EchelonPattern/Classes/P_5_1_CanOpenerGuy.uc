//=============================================================================
// P_5_1_CanOpenerGuy
//=============================================================================
class P_5_1_CanOpenerGuy extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
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
        if (P.name == 'EGeorgianPalaceGuard0')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Milestone:
    Log("MilestoneCan");
    CheckFlags(V5_1_1_PresidentialPalace(Level.VarObject).LaptopAccessed,FALSE,'End');
    DisableMessages(TRUE, TRUE);
    LockDoor('ESwingingDoorKeyPadLockedA', FALSE, TRUE);
    LockDoor('ESwingingDoorKeyPadLockedB', FALSE, TRUE);
    Sleep(0.10);
    SetExclusivity(FALSE);
    Goal_Set(1,GOAL_MoveTo,9,,,,'GuardStairsCanny',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,8,,'LookHereCanny','LookHereCanny','GuardStairsCanny',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
End:
    End();

}


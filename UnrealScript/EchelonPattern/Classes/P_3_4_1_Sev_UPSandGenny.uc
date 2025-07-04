//=============================================================================
// P_3_4_1_Sev_UPSandGenny
//=============================================================================
class P_3_4_1_Sev_UPSandGenny extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('AlarmCheck');
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

    if( !bInit )
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
    Log("This pattern tracks the generator and UPS states");
GennySwitch:
    Log("The generator switch has been flipped");
    SetFlags(V3_4_1Severonickel(Level.VarObject).GennyOn,TRUE);
    GoalCompleted('GENNY');
    CheckFlags(V3_4_1Severonickel(Level.VarObject).UPSOff,TRUE,'DishCriteriaMet');
    End();
UPSSwitch:
    Log("The UPS has been disabled");
    SetFlags(V3_4_1Severonickel(Level.VarObject).UPSOff,TRUE);
    GoalCompleted('UPS');
    CheckFlags(V3_4_1Severonickel(Level.VarObject).GennyOn,TRUE,'DishCriteriaMet');
    End();
DishCriteriaMet:
    Log("The criteria for disabling the dish have been met.");
    GoalCompleted('ALARM');
    LockDoor('ChokeDoor', FALSE, TRUE);
    SetFlags(V3_4_1Severonickel(Level.VarObject).DishDone,TRUE);
    SetFlags(V3_4_1Severonickel(Level.VarObject).SafeAlarm,TRUE);
    End();
AlarmCheck:
    Log("Checking to see if it is safe to have an alarm go off.");
    CheckFlags(V3_4_1Severonickel(Level.VarObject).SafeAlarm,TRUE,'DoNothing');
    SetProfileDeletion();
    GameOver(false, 0);
    End();
DoNothing:
    Log("Doing nothing");
    End();

}

defaultproperties
{
}

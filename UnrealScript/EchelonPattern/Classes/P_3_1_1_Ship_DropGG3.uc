//=============================================================================
// P_3_1_1_Ship_DropGG3
//=============================================================================
class P_3_1_1_Ship_DropGG3 extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int pass1;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('AlarmON');
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
    pass1=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
AlarmON:
    Log("alarm on so dont teleport");
    SetFlags(pass1,TRUE);
    End();
TeleOut:
    Log("");
    SetExclusivity(TRUE);
    CheckFlags(pass1,TRUE,'JumpFin');
    Teleport(1, 'PathNode104');
    ResetGroupGoals();
    Goal_Default(1,GOAL_Wait,9,,,,'PathNode104',,FALSE,,,,);
JumpFin:
    Log("");
    End();

}

defaultproperties
{
}

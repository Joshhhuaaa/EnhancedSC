//=============================================================================
// P_4_2_2_Abt_GrinkoDeadChek
//=============================================================================
class P_4_2_2_Abt_GrinkoDeadChek extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int GrinkoPass1;


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

    if (!bInit)
    {
    bInit=TRUE;
    GrinkoPass1=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Start:
    Log("");
    Sleep(1);
Grinko:
    Log("");
    CheckFlags(V4_2_2_Abattoir(Level.VarObject).DeadGrinko,FALSE,'Start');
TeamA1:
    Log("");
    CheckFlags(V4_2_2_Abattoir(Level.VarObject).DeadA1,FALSE,'NotAll');
TeamA2:
    Log("");
    CheckFlags(V4_2_2_Abattoir(Level.VarObject).DeadA2,FALSE,'NotAll');
OfficerC1:
    Log("");
    CheckFlags(V4_2_2_Abattoir(Level.VarObject).DeadC1,FALSE,'NotAll');
OfficerC2:
    Log("");
    CheckFlags(V4_2_2_Abattoir(Level.VarObject).DeadC2,FALSE,'NotAll');
    Log("Flag combat ended.  All member dead");
    SetFlags(V4_2_2_Abattoir(Level.VarObject).GrinkoCombatEnded,TRUE);
    Sleep(0.5);
    SendPatternEvent('EGroupAI27','GrinkoDead');
    End();
NotAll:
    Log("");
    CheckFlags(GrinkoPass1,TRUE,'Start');
    SendPatternEvent('EGroupAI27','GrinkoDead');
    SetFlags(GrinkoPass1,TRUE);
    End();

}


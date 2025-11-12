//=============================================================================
// P_4_1_2_CEmb_GateFlag
//=============================================================================
class P_4_1_2_CEmb_GateFlag extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int InsideGate;


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
    InsideGate=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
GateClosed:
    Log("The Gate is closed");
    CheckFlags(InsideGate,TRUE,'WentThrough');
    SendPatternEvent('LambertBogus','GameOver');
    End();
WentThrough:
    Log("Sam is through the gate AND the gate is closed");
    GoalCompleted('4_1_3');
    End();
    Log("Everything below here is added by Clint to fix bugs 2191 and 2192");
GoingThroughTrue:
    Log("Sam has gone through the gate");
    SetFlags(InsideGate,TRUE);
    End();
GoingThroughFalse:
    Log("Sam has gone back through the gate onto the streets");
    SetFlags(InsideGate,FALSE);
    End();

}


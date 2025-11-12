//=============================================================================
// P_4_1_2_CEmb_LimoLoop
//=============================================================================
class P_4_1_2_CEmb_LimoLoop extends EPattern;

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

    if (!bInit)
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
LimoLoop:
    Log("Limo is in place in front of the gate");
    CheckFlags(V4_1_2ChineseEmbassy(Level.VarObject).LimoAtFrontGate,TRUE,'LaserMicAtGateCompleted');
    Jump('Wait');
LaserMicAtGateCompleted:
    Log("LaserMicAtGateCompleted");
    CheckFlags(V4_1_2ChineseEmbassy(Level.VarObject).LaserMicCompleted,TRUE,'GuardInPosition');
    Jump('Wait');
GuardInPosition:
    Log("Check if the soldier is in the booth to open the gate");
    CheckFlags(V4_1_2ChineseEmbassy(Level.VarObject).GateGuardInPosition,FALSE,'Wait');
    Sleep(3);
    SendPatternEvent('FeirongGroup','MainGateOpen');
    End();
Wait:
    Log("Loop again if all conditions are not answered");
    Sleep(1);
    Jump('LimoLoop');

}


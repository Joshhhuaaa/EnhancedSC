//=============================================================================
// P_4_3_1_DummyA
//=============================================================================
class P_4_3_1_DummyA extends EPattern;

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
DestroyFeirongComputer:
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).DestroyFeirongComputer,TRUE);
    End();
CheckTriggers:
    Log("CheckTriggers");
    CheckFlags(V4_3_1ChineseEmbassy(Level.VarObject).RetinalSoldierSwitch,FALSE,'JumpBack');
    CheckFlags(V4_3_1ChineseEmbassy(Level.VarObject).RetinalColonelSwitch,FALSE,'JumpBack');
    SendPatternEvent('HallRetinalScanner','TriggerRetinalScanner');
    Jump('JumpBackB');
    End();
JumpBack:
    Log("JumpBack");
    Sleep(2);
    Jump('CheckTriggers');
    End();
JumpBackB:
    Log("JumpBackB");
    Sleep(2);
    Jump('JumpBack');
    End();

}


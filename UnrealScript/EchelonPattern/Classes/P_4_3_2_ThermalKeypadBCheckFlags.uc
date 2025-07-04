//=============================================================================
// P_4_3_2_ThermalKeypadBCheckFlags
//=============================================================================
class P_4_3_2_ThermalKeypadBCheckFlags extends EPattern;

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

    if( !bInit )
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
LoopKeypad:
    Log("LoopKeypad");
    CheckFlags(V4_3_2ChineseEmbassy(Level.VarObject).KeypadBExpiredToggle,TRUE,'CheckDoor');
    Jump('Wait');
CheckDoor:
    Log("CheckDoor");
    CheckFlags(V4_3_2ChineseEmbassy(Level.VarObject).KeypadBDoorClosed,TRUE,'CheckPlayerSide');
    Jump('Wait');
CheckPlayerSide:
    Log("CheckPlayerSide");
    CheckFlags(V4_3_2ChineseEmbassy(Level.VarObject).SamSwitch,FALSE,'CheckColonel');
    Jump('Wait');
CheckColonel:
    Log("CheckColonel");
    CheckFlags(V4_3_2ChineseEmbassy(Level.VarObject).KeypadBColonelSwitch,TRUE,'GameOver');
    Jump('Wait');
GameOver:
    Log("GameOver");
    SendPatternEvent('LambertComms','KeypadFailedB');
    End();
Wait:
    Log("Wait");
    Sleep(1);
    Jump('LoopKeypad');
EndLoop:
    Log("EndLoop");
    End();

}


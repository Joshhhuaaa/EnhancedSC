//=============================================================================
// P_4_3_2_ThermalKeypadBSetFlags
//=============================================================================
class P_4_3_2_ThermalKeypadBSetFlags extends EPattern;

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
KeypadBDoorOpen:
    Log("KeypadBDoorOpen");
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).KeypadBDoorClosed,FALSE);
    End();
KeypadBDoorClosed:
    Log("KeypadBDoorClosed");
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).KeypadBDoorClosed,TRUE);
    End();
SamSwitchON:
    Log("SamTriggerON");
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).SamSwitch,TRUE);
    End();
SamSwitchOFF:
    Log("SamTriggerOFF");
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).SamSwitch,FALSE);
    End();
KeypadBExpiredToggle:
    Log("KeypadBExpiredToggle");
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).KeypadBExpiredToggle,TRUE);
    End();
KeypadBColonelTriggerON:
    Log("KeypadBColonelTriggerON");
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).KeypadBColonelSwitch,TRUE);
    End();
KeypadBColonelTriggerOFF:
    Log("KeypadBColonelTriggerOFF");
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).KeypadBColonelSwitch,FALSE);
    End();
DisableLoop:
    Log("DisableLoop");
    End();
KeypadBCanKillColonel:
    Log("KeypadBCanKillColonel");
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).KeypadBColonelSwitch,TRUE);
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).CanKillKeypadB,TRUE);
    End();

}


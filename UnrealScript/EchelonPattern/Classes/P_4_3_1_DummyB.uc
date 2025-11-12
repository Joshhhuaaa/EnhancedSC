//=============================================================================
// P_4_3_1_DummyB
//=============================================================================
class P_4_3_1_DummyB extends EPattern;

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
        if (P.name == 'EAzeriColonel0')
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
SoldierTriggerOFF:
    Log("SoldierTriggerOFF");
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).RetinalSoldierSwitch,FALSE);
    End();
SoldierTriggerON:
    Log("SoldierTriggerON");
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).RetinalSoldierSwitch,TRUE);
    End();
ColonelTriggerOFF:
    Log("ColonelTriggerOFF");
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).RetinalColonelSwitch,FALSE);
    End();
DoorOK:
    Log("DoorOK");
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).DoorPassed,TRUE);
    End();
DoorNotOK:
    Log("DoorNotOK");
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).DoorPassed,FALSE);
    End();
ColonelTriggerON:
    Log("ColonelTriggerON");
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).RetinalColonelSwitch,TRUE);
    End();
ColonelRetinalForced:
    Log("ColonelRetinalForced");
    CheckIfGrabbed(1,'ReallyTheColonel');
    End();
ReallyTheColonel:
    Log("It's really the colonel who is forced into using the scanner and not a simple soldier.");
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).ColonelOnRetinal,TRUE);
    End();
SamTriggerON:
    Log("SamTriggerON");
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).SamSwitch,TRUE);
    End();
SamTriggerOFF:
    Log("SamTriggerOFF");
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).SamSwitch,FALSE);
    End();
KeypadExpired:
    Log("KeypadExpired");
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).KeypadExpiredToggle,TRUE);
    End();
DoorOpen:
    Log("DoorOpen");
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).ThermalKeypadADoorClosed,FALSE);
    End();
DoorClosed:
    Log("DoorClosed");
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).ThermalKeypadADoorClosed,TRUE);
    End();
KeypadAColonelTriggerOFF:
    Log("KeypadAColonelTriggerOFF");
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).KeypadAColonelSwitch,FALSE);
    End();
KeypadAColonelTriggerON:
    Log("KeypadAColonelTriggerON");
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).KeypadAColonelSwitch,TRUE);
    End();
KeypadASoldierTriggerOFF:
    Log("KeypadASoldierTriggerOFF");
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).KeypadASoldierSwitch,FALSE);
    End();
KeypadASoldierTriggerON:
    Log("KeypadASoldierTriggerON");
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).KeypadASoldierSwitch,TRUE);
    End();
DisableLoop:
    Log("DissableLoop");
    SendPatternEvent('SwitchDummyC','EndLoop');
    End();
KeypadUsed:
    Log("KeypadUsed");
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).KeypadWasUsed,TRUE);
    End();

}


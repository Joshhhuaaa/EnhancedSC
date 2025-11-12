//=============================================================================
// P_4_3_2_ThermalKeypadCSetFlags
//=============================================================================
class P_4_3_2_ThermalKeypadCSetFlags extends EPattern;

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
KeypadCDoorOpen:
    Log("KeypadCDoorOpen");
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).KeypadBDoorClosed,FALSE);
    End();
KeypadCDoorClosed:
    Log("KeypadCDoorClosed");
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).KeypadCDoorClosed,TRUE);
    End();
SamTriggerON:
    Log("SamTriggerON");
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).SamSwitchC,TRUE);
    End();
SamTriggerOFF:
    Log("SamTriggerOFF");
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).SamSwitchC,FALSE);
    End();
KeypadCExpiredToggle:
    Log("KeypadCExpiredToggle");
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).KeypadCExpiredToggle,TRUE);
    End();
KeypadCColonelTriggerON:
    Log("KeypadCColonelTriggerON");
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).KeypadCColonelSwitch,TRUE);
    End();
KeypadCColonelTriggerOFF:
    Log("KeypadCColonelTriggerOFF");
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).KeypadCColonelSwitch,FALSE);
    End();
DisableLoop:
    Log("DisableLoop");
    End();
SamInElevator:
    Log("SamInElevator");
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).SamInElevator,TRUE);
    CheckFlags(V4_3_2ChineseEmbassy(Level.VarObject).NPCwentInElev,FALSE,'JumpEarlyRanPast');
    End();
KeypadCLastDoorOK:
    Log("KeypadCLastDoorPassed");
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).KeypadCLastDoorCrossed,TRUE);
    End();
KeypadCLastDoorNOTOK:
    Log("KeypadCLastDoorNOTOK");
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).KeypadCLastDoorCrossed,FALSE);
    End();
JumpEarlyRanPast:
    Log("JumpEarlyRanPast");
    SendPatternEvent('LambertComms','KeypadFailedA');
    End();

}


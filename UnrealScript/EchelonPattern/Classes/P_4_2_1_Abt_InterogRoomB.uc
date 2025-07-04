//=============================================================================
// P_4_2_1_Abt_InterogRoomB
//=============================================================================
class P_4_2_1_Abt_InterogRoomB extends EPattern;

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
    Log("This is no longer an interrogation pattern...it strictly governs the states and operations of the antenna on the roof.");
ENABLEswitch:
    Log("Enabling the antenna switch");
    CheckFlags(V4_2_1_Abattoir(Level.VarObject).AlreadySwitched,TRUE,'DoNothing');
    CheckFlags(V4_2_1_Abattoir(Level.VarObject).SwitchActive,TRUE,'DoNothing');
    SetFlags(V4_2_1_Abattoir(Level.VarObject).SwitchActive,TRUE);
    SendUnrealEvent('AntennaSwitch');
    End();
DISABLEswitch:
    Log("Disabling the antenna switch");
    CheckFlags(V4_2_1_Abattoir(Level.VarObject).AlreadySwitched,TRUE,'DoNothing');
    CheckFlags(V4_2_1_Abattoir(Level.VarObject).SwitchActive,FALSE,'DoNothing');
    SetFlags(V4_2_1_Abattoir(Level.VarObject).SwitchActive,FALSE);
    SendUnrealEvent('AntennaSwitch');
    End();
SWITCHED:
    Log("The switch has been activated.");
    CheckFlags(V4_2_1_Abattoir(Level.VarObject).AlreadySwitched,TRUE,'DoNothing');
    SetFlags(V4_2_1_Abattoir(Level.VarObject).AlreadySwitched,TRUE);
    SendPatternEvent('EGroupAI27','NikoladzeOut');
    SendPatternEvent('EGroupAI1','TeleportSafe');
    End();
DoNothing:
    Log("Antenna Doing Nothing");
    End();

}


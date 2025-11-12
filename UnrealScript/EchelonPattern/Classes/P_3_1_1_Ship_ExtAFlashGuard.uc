//=============================================================================
// P_3_1_1_Ship_ExtAFlashGuard
//=============================================================================
class P_3_1_1_Ship_ExtAFlashGuard extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int pass1;


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
        if (P.name == 'spetsnaz42')
            Characters[1] = P.controller;
        if (P.name == 'EMafiaMuscle4')
            Characters[2] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    pass1=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
G42rdy:
    Log("guard 42 ready for patrol.  alert and flashlight on");
    ChangeState(1,'s_alert');
    SetFlashLight(1, TRUE);
    End();
G42NotRdy:
    Log("guard 42 out fo patrol mode. deafult and flashlight off");
    ChangeState(1,'s_default');
    SetFlashLight(1, FALSE);
    End();
ChekforSpetz31:
    Log("chek if spetz31 is alive");
    CheckIfGrabbed(3,'Alarm');
    CheckIfIsUnconscious(3,'Alarm');
    CheckIfIsDead(3,'Alarm');
    Goal_Set(1,GOAL_Action,9,,,,,'ReacStInHH2',FALSE,,,,);
    CheckFlags(pass1,FALSE,'JumpFin');
    Speech(Localize("P_3_1_1_Ship_ExtAFlashGuard", "Speech_0001L", "Localization\\P_3_1_1_ShipYard"), None, 3, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_1_1_Ship_ExtAFlashGuard", "Speech_0002L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Close();
    End();
Alarm:
    Log("mafia3 trigger alarm");
    Speech(Localize("P_3_1_1_Ship_ExtAFlashGuard", "Speech_0003L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_CONVERSATION, 0, false);
    Goal_Set(2,GOAL_InteractWith,9,,,,'EAlarmPanel7',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Patrol,8,,,,'spetsnaz45_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    ChangeState(2,'s_alert');
    Close();
    End();
SetTalk:
    Log("");
    SetFlags(pass1,TRUE);
    End();
JumpFin:
    Log("");
    End();

}

defaultproperties
{
}

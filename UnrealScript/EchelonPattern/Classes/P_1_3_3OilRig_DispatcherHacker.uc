//=============================================================================
// P_1_3_3OilRig_DispatcherHacker
//=============================================================================
class P_1_3_3OilRig_DispatcherHacker extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Check1;
var int Check2;
var int Check3;
var int Check4;
var int Check5;
var int Check6;


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
    Check1=0;
    Check2=0;
    Check3=0;
    Check4=0;
    Check5=0;
    Check6=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
    Log("This pattern is designed to stop the Dispatcher bug.");
CheckPointRouter:
    Log("Routes to the appropriate checkpoint.");
    Sleep(0.5);
    CheckFlags(Check6,TRUE,'Routed6');
    CheckFlags(Check5,TRUE,'Routed5');
    CheckFlags(Check4,TRUE,'Routed4');
    CheckFlags(Check3,TRUE,'Routed3');
    CheckFlags(Check2,TRUE,'Routed2');
    CheckFlags(Check1,TRUE,'Routed1');
    End();
Routed1:
    Log("Dispatcher hacker- only NPC checkpoint 1 completed.");
    SendUnrealEvent('Check1');
    End();
Routed2:
    Log("Dispatcher hacker- only NPC checkpoint 2 completed.");
    SendUnrealEvent('Check2');
    End();
Routed3:
    Log("Dispatcher hacker- only NPC checkpoint 3 completed.");
    SendUnrealEvent('Check3');
    End();
Routed4:
    Log("Dispatcher hacker- only NPC checkpoint 4 completed.");
    SendUnrealEvent('Check4');
    End();
Routed5:
    Log("Dispatcher hacker- NPC checkpoint 5 completed.");
    SendUnrealEvent('Check5');
    End();
Routed6:
    Log("Dispatcher hacker- NPC checkpoint 6 completed.");
    SendUnrealEvent('Check6');
    End();
Nada:
    End();
Check1:
    Log("NPC checkpoint 1 reached.");
    SetFlags(Check1,TRUE);
    End();
Check2:
    Log("NPC checkpoint 2 reached.");
    SetFlags(Check2,TRUE);
    End();
Check3:
    Log("NPC checkpoint 3 reached.");
    SetFlags(Check3,TRUE);
    End();
Check4:
    Log("NPC checkpoint 4 reached.");
    SetFlags(Check4,TRUE);
    End();
Check5:
    Log("NPC checkpoint 5 reached.");
    SetFlags(Check5,TRUE);
    End();
Check6:
    Log("NPC checkpoint 6 reached.");
    SetFlags(Check6,TRUE);
    End();

}


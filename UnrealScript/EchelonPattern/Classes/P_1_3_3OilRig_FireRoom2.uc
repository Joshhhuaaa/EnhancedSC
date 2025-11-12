//=============================================================================
// P_1_3_3OilRig_FireRoom2
//=============================================================================
class P_1_3_3OilRig_FireRoom2 extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Fire2Out;


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
    Fire2Out=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
FlameOn:
    Log("Seriously, we didn't do it.");
    SendUnrealEvent('Fire2');
    End();
Faucet2:
    Log("");
    CheckFlags(Fire2Out,TRUE,'Nada');
    SetFlags(Fire2Out,TRUE);
    SendUnrealEvent('Smoke2');
    Sleep(3.3);
    SendUnrealEvent('Fire2');
    End();
OilCircOneFire:
    Log("Oil Circulator one is burning");
    SendUnrealEvent('CircOilOneRad');
    Sleep(13);
    SendUnrealEvent('CircOilOneRad');
    End();
OilCircTwoFire:
    Log("Oil Circulator two is on fire");
    SendUnrealEvent('CircOilTwoRad');
    Sleep(13);
    SendUnrealEvent('CircOilTwoRad');
    End();
Nada:
    End();

}


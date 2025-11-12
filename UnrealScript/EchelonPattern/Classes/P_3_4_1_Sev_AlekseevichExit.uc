//=============================================================================
// P_3_4_1_Sev_AlekseevichExit
//=============================================================================
class P_3_4_1_Sev_AlekseevichExit extends EPattern;

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
        if (P.name == 'spetsnaz0')
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
    Log("[NEiL] I have enlisted this formerly defunct pattern for the well being of the collective.  Not only will it change the map when requested, but it shall control the funk lights.");
LevelChange:
    Log("Punts to 3.4.2.");
    LevelChange("3_4_2Severonickel");
    End();
FirstGeneratorLights:
    Log("Lighting system for the first generator.");
    DisableMessages(TRUE, TRUE);
    JumpRandom('FirstGeneratorLightOne', 0.20, 'FirstGeneratorLightTwo', 0.40, 'FirstGeneratorLightThree', 0.60, 'FirstGeneratorLightFour', 0.80, 'FirstGeneratorLightFive', 1.00); 
FirstGeneratorLightOne:
    Log("First light cascade configuration.");
    SendUnrealEvent('FirstGeneratorLightOne');
    Sleep(0.0625);
    SendUnrealEvent('FirstGeneratorLightTwo');
    SendUnrealEvent('FirstGeneratorLightThree');
    Sleep(0.1);
    SendUnrealEvent('FirstGeneratorLightFour');
    SendUnrealEvent('FirstGeneratorLightFive');
    Sleep(0.0625);
    SendUnrealEvent('FirstGeneratorLightSix');
    Jump('FirstGeneratorCascadeDone');
FirstGeneratorLightTwo:
    Log("Second light cascade configuration.");
    SendUnrealEvent('FirstGeneratorLightFive');
    SendUnrealEvent('FirstGeneratorLightThree');
    Sleep(0.1);
    SendUnrealEvent('FirstGeneratorLightTwo');
    SendUnrealEvent('FirstGeneratorLightSix');
    Sleep(0.0625);
    SendUnrealEvent('FirstGeneratorLightOne');
    Sleep(0.0625);
    SendUnrealEvent('FirstGeneratorLightFour');
    Jump('FirstGeneratorCascadeDone');
FirstGeneratorLightThree:
    Log("Third light cascade configuration.");
    SendUnrealEvent('FirstGeneratorLightThree');
    SendUnrealEvent('FirstGeneratorLightFour');
    SendUnrealEvent('FirstGeneratorLightOne');
    Sleep(0.0625);
    SendUnrealEvent('FirstGeneratorLightSix');
    Sleep(0.0625);
    SendUnrealEvent('FirstGeneratorLightFive');
    Sleep(0.1);
    SendUnrealEvent('FirstGeneratorLightTwo');
    Jump('FirstGeneratorCascadeDone');
FirstGeneratorLightFour:
    Log("Fourth light cascade configuration.");
    SendUnrealEvent('FirstGeneratorLightTwo');
    Sleep(0.0625);
    SendUnrealEvent('FirstGeneratorLightSix');
    SendUnrealEvent('FirstGeneratorLightFour');
    Sleep(0.1);
    SendUnrealEvent('FirstGeneratorLightFive');
    Sleep(0.0625);
    SendUnrealEvent('FirstGeneratorLightOne');
    SendUnrealEvent('FirstGeneratorLightThree');
    Jump('FirstGeneratorCascadeDone');
FirstGeneratorLightFive:
    Log("Fifth light cascade configuration.");
    SendUnrealEvent('FirstGeneratorLightFive');
    SendUnrealEvent('FirstGeneratorLightFour');
    Sleep(0.0625);
    SendUnrealEvent('FirstGeneratorLightTwo');
    SendUnrealEvent('FirstGeneratorLightThree');
    Sleep(0.1);
    SendUnrealEvent('FirstGeneratorLightSix');
    Sleep(0.0625);
    SendUnrealEvent('FirstGeneratorLightOne');
    Jump('FirstGeneratorCascadeDone');
FirstGeneratorCascadeDone:
    Log("The first generator cascade is complete, reactivating the switch.");
    DisableMessages(FALSE, FALSE);
    End();

}

defaultproperties
{
}

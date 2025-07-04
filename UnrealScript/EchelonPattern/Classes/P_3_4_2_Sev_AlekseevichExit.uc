//=============================================================================
// P_3_4_2_Sev_AlekseevichExit
//=============================================================================
class P_3_4_2_Sev_AlekseevichExit extends EPattern;

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

    ForEach DynamicActors(class'Pawn', P)
    {
        if(P.name == 'spetsnaz0')
            Characters[1] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
    Log("[NEiL] Once again, I have co-opted this pattern for the well being and ultimate cultural supremecy of Mother Russia.  It shall control the light, and the shadow, in which Sam is able to hide. Yeah... hide.");
HitTheLights:
    Log("Activates or deactivates the elaborate lighting system.");
    DisableMessages(TRUE, TRUE);
    JumpRandom('LightCascadeOne', 0.20, 'LightCascadeTwo', 0.40, 'LightCascadeThree', 0.60, 'LightCascadeFour', 0.80, 'LightCascadeFive', 1.00); 
LightCascadeOne:
    Log("First light cascade configuration.");
    SendUnrealEvent('FunkLightOne');
    SendUnrealEvent('FunkLightFour');
    Sleep(0.08);
    SendUnrealEvent('FunkLightFive');
    Sleep(0.1175);
    SendUnrealEvent('FunkLightThree');
    Sleep(0.08);
    SendUnrealEvent('FunkLightTwo');
    SendUnrealEvent('FunkLightSix');
    Jump('CascadeDone');
LightCascadeTwo:
    Log("Second light cascade configuration.");
    SendUnrealEvent('FunkLightFive');
    Sleep(0.08);
    SendUnrealEvent('FunkLightTwo');
    SendUnrealEvent('FunkLightThree');
    Sleep(0.08);
    SendUnrealEvent('FunkLightSix');
    SendUnrealEvent('FunkLightOne');
    Sleep(0.1175);
    SendUnrealEvent('FunkLightFour');
    Jump('CascadeDone');
LightCascadeThree:
    Log("Third light cascade configuration.");
    SendUnrealEvent('FunkLightFour');
    SendUnrealEvent('FunkLightThree');
    SendUnrealEvent('FunkLightOne');
    Sleep(0.1175);
    SendUnrealEvent('FunkLightFive');
    Sleep(0.08);
    SendUnrealEvent('FunkLightSix');
    Sleep(0.08);
    SendUnrealEvent('FunkLightTwo');
    Jump('CascadeDone');
LightCascadeFour:
    Log("Fourth light cascade configuration.");
    SendUnrealEvent('FunkLightTwo');
    Sleep(0.1175);
    SendUnrealEvent('FunkLightSix');
    Sleep(0.08);
    SendUnrealEvent('FunkLightFour');
    SendUnrealEvent('FunkLightThree');
    Sleep(0.1);
    SendUnrealEvent('FunkLightFive');
    SendUnrealEvent('FunkLightOne');
    Jump('CascadeDone');
LightCascadeFive:
    Log("Fifth light cascade configuration.");
    SendUnrealEvent('FunkLightThree');
    SendUnrealEvent('FunkLightOne');
    Sleep(0.1);
    SendUnrealEvent('FunkLightSix');
    SendUnrealEvent('FunkLightTwo');
    Sleep(0.1175);
    SendUnrealEvent('FunkLightFour');
    Sleep(0.08);
    SendUnrealEvent('FunkLightFive');
    Jump('CascadeDone');
CascadeDone:
    Log("Reactivating the switch, the cascade is finished.");
    DisableMessages(FALSE, FALSE);
    End();
HitTheTechLights:
    Log("Activates or deactivates the elaborate lighting system in the Tech room.");
    DisableMessages(TRUE, TRUE);
    JumpRandom('TechCascadeOne', 0.20, 'TechCascadeTwo', 0.40, 'TechCascadeThree', 0.60, 'TechCascadeFour', 0.80, 'TechCascadeFive', 1.00); 
TechCascadeOne:
    Log("");
    SendUnrealEvent('TechRoomLightOne');
    SendUnrealEvent('TechRoomLightTwo');
    SendUnrealEvent('TechRoomLightThree');
    Sleep(0.0625);
    SendUnrealEvent('TechRoomLightFour');
    Sleep(0.1);
    SendUnrealEvent('TechRoomLightFive');
    Sleep(0.0625);
    SendUnrealEvent('TechRoomLightSix');
    Jump('TechCascadeDone');
TechCascadeTwo:
    Log("");
    SendUnrealEvent('TechRoomLightThree');
    Sleep(0.1);
    SendUnrealEvent('TechRoomLightSix');
    SendUnrealEvent('TechRoomLightFive');
    Sleep(0.0625);
    SendUnrealEvent('TechRoomLightOne');
    Sleep(0.0625);
    SendUnrealEvent('TechRoomLightFour');
    SendUnrealEvent('TechRoomLightTwo');
    Jump('TechCascadeDone');
TechCascadeThree:
    Log("");
    SendUnrealEvent('TechRoomLightFive');
    SendUnrealEvent('TechRoomLightTwo');
    Sleep(0.0625);
    SendUnrealEvent('TechRoomLightSix');
    SendUnrealEvent('TechRoomLightThree');
    Sleep(0.0625);
    SendUnrealEvent('TechRoomLightOne');
    Sleep(0.1);
    SendUnrealEvent('TechRoomLightFour');
    Jump('TechCascadeDone');
TechCascadeFour:
    Log("");
    SendUnrealEvent('TechRoomLightFour');
    Sleep(0.0625);
    SendUnrealEvent('TechRoomLightOne');
    SendUnrealEvent('TechRoomLightTwo');
    Sleep(0.1);
    SendUnrealEvent('TechRoomLightSix');
    Sleep(0.0625);
    SendUnrealEvent('TechRoomLightFive');
    SendUnrealEvent('TechRoomLightThree');
    Jump('TechCascadeDone');
TechCascadeFive:
    Log("");
    SendUnrealEvent('TechRoomLightTwo');
    SendUnrealEvent('TechRoomLightThree');
    Sleep(0.0625);
    SendUnrealEvent('TechRoomLightSix');
    Sleep(0.0625);
    SendUnrealEvent('TechRoomLightOne');
    Sleep(0.1);
    SendUnrealEvent('TechRoomLightFour');
    SendUnrealEvent('TechRoomLightFive');
    Jump('TechCascadeDone');
TechCascadeDone:
    Log("Reactivating the switch, the Tech cascade is finished.");
    DisableMessages(FALSE, FALSE);
    End();
HittheTroisLights:
    Log("");
    DisableMessages(TRUE, TRUE);
    JumpRandom('TroisCascadeOne', 0.20, 'TroisCascadeTwo', 0.40, 'TroisCascadeThree', 0.60, 'TroisCascadeFour', 0.80, 'TroisCascadeFive', 1.00); 
TroisCascadeOne:
    Log("");
    SendUnrealEvent('TroisLightsOne');
    Sleep(0.088);
    SendUnrealEvent('TroisLightsTwo');
    Sleep(0.05);
    SendUnrealEvent('TroisLightsThree');
    Jump('TroisCascadeDone');
TroisCascadeTwo:
    Log("");
    SendUnrealEvent('TroisLightsThree');
    Sleep(0.088);
    SendUnrealEvent('TroisLightsTwo');
    Sleep(0.05);
    SendUnrealEvent('TroisLightsOne');
    Jump('TroisCascadeDone');
TroisCascadeThree:
    Log("");
    SendUnrealEvent('TroisLightsTwo');
    Sleep(0.088);
    SendUnrealEvent('TroisLightsOne');
    Sleep(0.05);
    SendUnrealEvent('TroisLightsThree');
    Jump('TroisCascadeDone');
TroisCascadeFour:
    Log("");
    SendUnrealEvent('TroisLightsThree');
    Sleep(0.05);
    SendUnrealEvent('TroisLightsOne');
    Sleep(0.088);
    SendUnrealEvent('TroisLightsTwo');
    Jump('TroisCascadeDone');
TroisCascadeFive:
    Log("");
    SendUnrealEvent('TroisLightsOne');
    Sleep(0.05);
    SendUnrealEvent('TroisLightsThree');
    Sleep(0.088);
    SendUnrealEvent('TroisLightsTwo');
    Jump('TroisCascadeDone');
TroisCascadeDone:
    Log("");
    DisableMessages(FALSE, FALSE);
    End();

}

defaultproperties
{
}

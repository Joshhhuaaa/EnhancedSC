//=============================================================================
// P_4_3_2_WarehouseTrucks
//=============================================================================
class P_4_3_2_WarehouseTrucks extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_3_2Voice.uax
#exec OBJ LOAD FILE=..\Sounds\Vehicules.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int TruckAExploded;
var int TruckBExploded;


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
    local Actor A;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'EChineseSoldier21')
            Characters[1] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if (A.name == 'EVan0')
            SoundActors[0] = A;
        if (A.name == 'EVan1')
            SoundActors[1] = A;
        if (A.name == 'ESoundTrigger19')
            SoundActors[2] = A;
    }

    if (!bInit)
    {
    bInit=TRUE;
    TruckAExploded=0;
    TruckBExploded=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
TruckMoving:
    Log("TruckDeparture");
    CinCamera(0, 'TruckCinematicPosition01', 'TruckCinematicTarget01',);
    Sleep(1);
    Talk(Sound'S4_3_2Voice.Play_43_31_01', 1, , TRUE, 0);
    CinCamera(1, , ,);
    CinCamera(0, 'TruckCinematicPosition02', 'TruckCinematicTarget01',);
    Talk(Sound'S4_3_2Voice.Play_43_31_02', 1, , TRUE, 0);
    Close();
    Goal_Set(1,GOAL_Action,9,,,,,'PumpStNmEd0',FALSE,,,,);
    Sleep(0.2);
    SendUnrealEvent('ThePump');
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PumpistClimbingTruckTeleport01',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(2);
    CinCamera(1, , ,);
    WaitForGoal(1,GOAL_MoveTo,);
    Teleport(1, 'PumpistClimbingTruckTeleport02');
    Sleep(20);
	SoundActors[1].PlaySound(Sound'Vehicules.Play_TruckStart', SLOT_SFX);
    SendUnrealEvent('Truck2');
    Sleep(5);
	SoundActors[0].PlaySound(Sound'Vehicules.Play_TruckStart', SLOT_SFX);
    SendUnrealEvent('Truck1');
    Sleep(20);
    SendUnrealEvent('WareHouseGate1');
    Sleep(3);
    SendUnrealEvent('Truck2');
    Sleep(8);
    SendUnrealEvent('Truck1');
    Sleep(10);
    SendPatternEvent('LambertComms','TruckFailed');
    End();
TruckAExplode:
    Log("TruckAExplode");
	SoundActors[1].PlaySound(Sound'Vehicules.Stop_TruckIdle', SLOT_SFX);
    SetFlags(TruckAExploded,TRUE);
    CheckFlags(TruckBExploded,TRUE,'TruckABExplode');
    SendUnrealEvent('WareHouseGate1');
    Sleep(12);
	SoundActors[0].PlaySound(Sound'Vehicules.Play_TruckStart', SLOT_SFX);
    SendUnrealEvent('Truck1');
    Sleep(8);
    SendPatternEvent('LambertComms','TruckFailed');
    End();
TruckBExplode:
    Log("TruckBExplode");
	SoundActors[0].PlaySound(Sound'Vehicules.Stop_TruckIdle', SLOT_SFX);
    SetFlags(TruckBExploded,TRUE);
    CheckFlags(TruckAExploded,TRUE,'TruckABExplode');
    SendUnrealEvent('WareHouseGate1');
    Sleep(12);
	SoundActors[1].PlaySound(Sound'Vehicules.Play_TruckStart', SLOT_SFX);
    SendUnrealEvent('Truck2');
    Sleep(8);
    SendPatternEvent('LambertComms','TruckFailed');
    End();
TruckABExplode:
    Log("TruckABExplode");
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).TruckObjectiveDone,TRUE);
    Sleep(2);
    SendUnrealEvent('TruckExplodeSaveGame');
    SendPatternEvent('RebelArmyPanics','4340');
    End();

}


//=============================================================================
// P_3_4_3_Sev_Finale
//=============================================================================
class P_3_4_3_Sev_Finale extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int OKforFinale;


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
        if(P.name == 'EWilkes0')
            Characters[1] = P.controller;
        if(P.name == 'ESamNPC1')
            Characters[2] = P.controller;
        if(P.name == 'spetsnaz0')
            Characters[3] = P.controller;
        if(P.name == 'spetsnaz1')
            Characters[4] = P.controller;
        if(P.name == 'spetsnaz2')
            Characters[5] = P.controller;
        // Joshua - Hack to prevent PlayerIdentified from explosion during cinematic
        if(P.name == 'spetsnaz4')
            Characters[6] = P.controller;
        if(P.name == 'spetsnaz6')
            Characters[7] = P.controller;
        if(P.name == 'spetsnaz7')
            Characters[8] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    OKforFinale=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
    Log("This is the pattern for the Osprey and the Final cutscene");
IsOspreySafe:
    Log("Checking to see if the SAMs and Server are deactivated so the Osprey can come.");
    CheckFlags(V3_4_3Severonickel(Level.VarObject).OneSAMActive,FALSE,'CheckServer');
    End();
CheckServer:
    Log("The SAMs are down, checking the server");
    CheckFlags(V3_4_3Severonickel(Level.VarObject).ServerActive,FALSE,'SetUp');
    End();
SetUp:
    Log("It is safe to put the Osprey and other actors in their final positions.");
    LockDoor('DoorLockedTilEnd', FALSE, TRUE);
    SetFlags(OKforFinale,TRUE);
    Log("insert cinematic stuff here with Osprey flying over, SAMs exploding, Osprey landing, Wilkes and spetznas fighting.");
    // Joshua - Hack to prevent PlayerIdentified from explosion during cinematic
    EAIController(Characters[6]).bNotInStats = true;
    EAIController(Characters[7]).bNotInStats = true;
    EAIController(Characters[8]).bNotInStats = true;
    CinCamera(0, 'Finale10Cam', 'Finale10Foc',);
    Sleep(1);
    SendUnrealEvent('Osprey');
    SendUnrealEvent('Osprey');
    SendUnrealEvent('SAM2Boom');
    Sleep(0.5);
    SendUnrealEvent('SAM2Boom');
    Sleep(1);
    CinCamera(0, 'Finale20Cam', 'Finale20Foc',);
    Sleep(0.25);
    SendUnrealEvent('SAM1Boom');
    Sleep(0.75);
    SendUnrealEvent('SAM1Boom');
    CinCamera(1, , ,);
    // Joshua - Hack to prevent PlayerIdentified from explosion during cinematic
    EAIController(Characters[6]).bNotInStats = false;
    EAIController(Characters[7]).bNotInStats = false;
    EAIController(Characters[8]).bNotInStats = false;
    End();
LaunchTest:
    Log("Checking if its okay to launch the finale");
    CheckFlags(OKforFinale,TRUE,'BlastOff');
    End();
BlastOff:
    Log("Launching the final sequence");
    Log("insert cinematic here of Sam running from the door to the Osprey as Wilkes gets shot by spetznas");
    Sleep(1);
    Teleport(0, 'PlayerOut');
    Teleport(2, 'NPCSamIn');
    PlayerMove(false);
    CinCamera(0, 'Finale30Cam', 'Finale30Foc',);
    SendUnrealEvent('Osprey');
    Goal_Set(2,GOAL_MoveTo,9,,,,'SamRunHere',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    SendUnrealEvent('FinalDoors');
    Sleep(2);
    Teleport(1, 'WilkesIn');
    CinCamera(0, 'Finale40Cam', 'Finale40Foc',);
    SendUnrealEvent('SAM3Boom');
    Sleep(0.5);
    SendUnrealEvent('SAM3Boom');
    Goal_Default(1,GOAL_Guard,0,,,,'WilkesDies',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_Attack,9,,'spetsnaz','spetsnaz',,,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(3,GOAL_MoveTo,9,,,,'FinMem3Attack',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(4,GOAL_MoveTo,9,,,,'FinMem4Attack',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(5,GOAL_MoveTo,9,,,,'FinMem5Attack',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Attack,0,,,'WilkesDies',,,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Default(4,GOAL_Attack,0,,,'WilkesDies',,,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Default(5,GOAL_Attack,0,,,'WilkesDies',,,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    WaitForGoal(2,GOAL_MoveTo,);
    CinCamera(0, 'Finale50Cam', 'Finale50Foc',);
    Sleep(1);
    KillNPC(1, FALSE, FALSE);
    Goal_Set(2,GOAL_MoveTo,9,,,,'PathNode',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_MoveTo,9,,,,'WilkesDies',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Sleep(2);
    SendUnrealEvent('Osprey');
    Sleep(5);
    GameOver(true, 0);
    End();

}

defaultproperties
{
}

//=============================================================================
// P_1_3_3OilRig_ChopperExplosion
//=============================================================================
class P_1_3_3OilRig_ChopperExplosion extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int AlreadyFlag;
var int Early;
var int Ready;
var int Regular;


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
        // Joshua - These are the NPCs who explode from the chopper cinematic, it shouldn't be included in stats
        if(P.name == 'EGeorgianSoldier6')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bNotInStats = true;
        }
        if(P.name == 'EGeorgianSoldier7')
        {
            Characters[2] = P.controller;
            EAIController(Characters[2]).bNotInStats = true;
        }
        if(P.name == 'EGeorgianSoldier8')
        {
            Characters[3] = P.controller;
            EAIController(Characters[3]).bNotInStats = true;
        }
        if(P.name == 'EGeorgianSoldier9')
        {
            Characters[4] = P.controller;
            EAIController(Characters[4]).bNotInStats = true;
        }
    }

    if( !bInit )
    {
    bInit=TRUE;
    AlreadyFlag=0;
    Early=0;
    Ready=0;
    Regular=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
BoomSya:
    Log("Sidewinder missile slams into the Georgian helicopter.");
    CheckFlags(Ready,FALSE,'Null');
    CheckFlags(Early,TRUE,'AlreadyDone');
    CheckFlags(Regular,TRUE,'Null');
    SetFlags(Regular,TRUE);
    DisableMessages(TRUE, TRUE);
    SendUnrealEvent('StairBlocker');
    SendUnrealEvent('ChopperCineDisable');
    SendUnrealEvent('ChopperCineDisableTwo');
    CinCamera(0, 'cameralocus', 'newone',);
    SendPatternEvent('TopDudes','GoodEyeOpen');
    SendUnrealEvent('Missile');
    SendUnrealEvent('MissileSmoke');
    SendUnrealEvent('BoatMover');
    SendUnrealEvent('BoatWreckMover');
    Sleep(1.8);
    SendPatternEvent('DannyAI','JerkOff');
    SendPatternEvent('JustinAI','JerkOff');
    LockDoor('SassyDoor', FALSE, TRUE);
    LockDoor('Otherdoor', FALSE, TRUE);
    LockDoor('fencedooruno', FALSE, TRUE);
    LockDoor('fencedoordos', FALSE, TRUE);
    SendUnrealEvent('ChopChop');
    ShakeCamera(1600, 14000, 2750);
    KillNPC(1, FALSE, FALSE);
    KillNPC(2, FALSE, FALSE);
    KillNPC(3, FALSE, FALSE);
    KillNPC(4, FALSE, FALSE);
mojo:
    Log("");
    SendPatternEvent('Merctech2AI','Boom');
    SendPatternEvent('escort2AI','ChopChop');
    SendPatternEvent('USCorpse','DieGorman');
    Sleep(2.5);
    ShakeCamera(700, 20000, 4000);
    SendUnrealEvent('ChopperSecondaryExplosion');
    Sleep(0.75);
    ShakeCamera(500, 20000, 4000);
    SendUnrealEvent('ChopperSecondaryExplosionTwo');
    Sleep(0.25);
    ShakeCamera(460, 22000, 3600);
    SendUnrealEvent('ChopperSecondaryExplosionThree');
    Sleep(0.25);
    ShakeCamera(400, 22000, 3600);
    SendUnrealEvent('ChopperSecondaryExplosionThree');
    Sleep(1.75);
    CinCamera(1, , ,);
    DisableMessages(FALSE, FALSE);
    SendUnrealEvent('ChopperCineEnableTwo');
    SendUnrealEvent('StairBlocker');
    Teleport(1, 'ChopDeadOne');
    Teleport(2, 'ChopDeadTwo');
    Teleport(3, 'ChopDeadThree');
    Teleport(4, 'ChopDeadFour');
    CinCamera(0, 'RunCamera', 'RunTarget',);
    Sleep(1);
    SendUnrealEvent('PostChopExpExp');
    ShakeCamera(700, 14000, 4444);
    Sleep(2);
    CinCamera(1, , ,);
    SendUnrealEvent('ChopperCineEnable');
    Sleep(14);
    SendUnrealEvent('PostChopExpExp');
    ShakeCamera(700, 16000, 4000);
    End();
AlreadyDone:
    Log("Cinematic starts here if chop already blown.");
    CheckFlags(AlreadyFlag,TRUE,'Null');
    SetFlags(AlreadyFlag,TRUE);
    SendPatternEvent('MercTech2AI','BoomTwo');
    SendPatternEvent('escort2AI','ChopChopTwo');
    CinCamera(0, 'RunCamera', 'RunTarget',);
    Sleep(2);
    SendUnrealEvent('PostChopExpExp');
    SendPatternEvent('USCorpse','DieGorman');
    SendPatternEvent('DannyAI','JerkOff');
    SendPatternEvent('JustinAI','JerkOff');
    ShakeCamera(700, 14000, 4444);
    Sleep(2);
    CinCamera(1, , ,);
    End();
Panic:
    Log("This is when we kill the danca!  Death of The Prodigy danca!!  Everybody run around like chickens with their heads cut off!");
    ChangeGroupState('s_alert');
    SetExclusivity(TRUE);
    Goal_Default(1,GOAL_Patrol,2,,,,'Lars1_100',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(2,GOAL_Patrol,2,,,,'James1_100',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(3,GOAL_Patrol,2,,,,'Jason1_100',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(4,GOAL_Patrol,2,,,,'Kirk1_100',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
Ready:
    Log("Primes the chopper explosion.");
    SetFlags(Ready,TRUE);
Null:
    End();
EarlyChop:
    Log("Sam is being naughty and getting on the top floor early, so like a spiteful god I shall remove his stairway to the heavens.");
    CheckFlags(Regular,TRUE,'Null');
    CheckFlags(Early,TRUE,'Null');
    SetFlags(Early,TRUE);
    SendUnrealEvent('ChopChop');
    ShakeCamera(1500, 14000, 2750);
    KillNPC(1, FALSE, TRUE);
    KillNPC(2, FALSE, TRUE);
    KillNPC(3, FALSE, TRUE);
    KillNPC(4, FALSE, TRUE);
    SendPatternEvent('TopDudes','EarlyChop');
    SendPatternEvent('Blindsider','EarlyChop');
    Teleport(1, 'ChopDeadOne');
    Teleport(2, 'ChopDeadTwo');
    Teleport(3, 'ChopDeadThree');
    Teleport(4, 'ChopDeadFour');
    End();

}


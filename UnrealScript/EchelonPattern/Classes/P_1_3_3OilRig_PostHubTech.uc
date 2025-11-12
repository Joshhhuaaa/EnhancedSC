//=============================================================================
// P_1_3_3OilRig_PostHubTech
//=============================================================================
class P_1_3_3OilRig_PostHubTech extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int BlahDoor;
var int FireComplete;
var int HallCrash;
var int HubWindow;
var int LaptopAcquired;
var int PathSelected;
var int SpecialDoor;
var int Teased;
var int TechRanAlready;
var int Trippin;


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
        if (P.name == 'EMercenaryTechnician1')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    BlahDoor=0;
    FireComplete=0;
    HallCrash=0;
    HubWindow=0;
    LaptopAcquired=0;
    PathSelected=0;
    SpecialDoor=0;
    Teased=0;
    TechRanAlready=0;
    Trippin=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
RunAway:
    Log("Switcharoo.");
    SendUnrealEvent('Jed2Enable');
    Teleport(1, 'Piotr_3500');
    Goal_Set(1,GOAL_Wait,1,,'MiddleComp','MiddleComp',,,FALSE,,,,);
    End();
Run:
    Log("Starts Jed a runnin");
    SendUnrealEvent('HubDoor2');
    SendPatternEvent('Blindsider','Hub');
    SetFlags(HubWindow,TRUE);
    ResetGoals(1);
    ChangeState(1,'s_alert');
    Goal_Set(1,GOAL_MoveTo,9,,,,'HubJunctionNode',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,8,,,,'midstairs',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveTo,);
    WaitForGoal(1,GOAL_MoveTo,);
    Teleport(1, 'TechHold2');
    End();
Boom:
    Log("Post-chopper explosion.");
    Sleep(4);
    Teleport(1, 'midstairs');
    Sleep(0.25);
    Goal_Set(1,GOAL_MoveTo,8,,,,'RunningShot',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(5.5);
    Teleport(1, 'TechHold2');
    SendPatternEvent('FireAI','Flame2');
    Goal_Set(1,GOAL_Wait,7,,,,,,TRUE,,,,);
    End();
BoomTwo:
    Log("Cinematic pattern for Piotr, minus explosion.  This is a backup pattern.");
    Teleport(1, 'midstairs');
    Goal_Set(1,GOAL_MoveTo,8,,,,'RunningShot',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(5.5);
    Teleport(1, 'TechHold2');
    SendPatternEvent('FireAI','Flame2');
    Goal_Set(1,GOAL_Wait,7,,,,,,TRUE,,,,);
    End();
Tease:
    Log("This is the Piotr Tease sequence.");
    SendPatternEvent('LastHurdleAI','Fight');
    ResetGoals(1);
    Teleport(1, 'Teaser');
    LockDoor('FenceDoorC', FALSE, TRUE);
    SendUnrealEvent('FenceDoorC');
    Sleep(0.1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'TeleOut',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    SendUnrealEvent('TeaseCineDisable');
    CinCamera(0, 'TeaseCineLocus', 'TeaseCineFocus',);
    Sleep(7.8);
    CinCamera(1, , ,);
    SetFlags(Teased,TRUE);
    SendUnrealEvent('TeaseCineEnable');
    AddRecon(class 'EReconInfWaterValve');
    Teleport(1, 'TechHold2');
    ResetGoals(1);
    Sleep(3);
    SendUnrealEvent('AfterTeaseExplosionSound');
    ShakeCamera(600, 20000, 4000);
    End();
NaughtySam:
    Log("Will collapse the hallway if Sam is going the wrong way instead of into the Fire Room.");
    CheckFlags(Teased,FALSE,'Jojo');
    CheckFlags(HallCrash,TRUE,'Jojo');
    SetFlags(HallCrash,TRUE);
    ShakeCamera(888, 20000, 4444);
    SendUnrealEvent('HallCrashDisp');
    End();
Staircrash:
    Log("What is this Staircrash, a virus, a religion or what?  What's the difference?");
    CheckFlags(Trippin,FALSE,'Jojo');
    Log("Take em out (flag check passed).");
    GoalCompleted('1_3_3');
    SendPatternEvent('LambertAI','GetOut');
    SetFlags(LaptopAcquired,TRUE);
    End();
Jojo:
    Log("Mojo");
    End();
LaptopCheck:
    Log("Checks to see if the laptop has been acquired before the level switch.");
    CheckFlags(LaptopAcquired,FALSE,'Jojo');
    SendPatternEvent('LambertAI','LevelSwitch');
    End();
Telegize:
    Log("Has the fire room been activated?  If so, teleport Piotr.");
    CheckFlags(FireComplete,FALSE,'Jojo');
    CheckFlags(SpecialDoor,TRUE,'Jojo');
    SetFlags(Trippin,TRUE);
    SendUnrealEvent('FenceDoor');
    JumpRandom('Tele1', 0.37, 'Tele2', 0.70, 'Tele3', 1.00, , , ,); 
Tele1:
    Teleport(1, 'Piotr_900');
    Jump('RunLikeHell');
Tele2:
    Teleport(1, 'Danny_100');
    Jump('RunLikeHell');
Tele3:
    Teleport(1, 'Kittie');
RunLikeHell:
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'Adam_700',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,8,,,,'Maynard_500',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,7,,,,'Piotr_300',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,6,,,,'PiotrTele',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Stop,2,,'Trashed','Trashed','PiotrTele','WaitCrAlFd0',FALSE,999999,,,);
    End();
FireComplete:
    Log("FireRoom activated, Piotr teleport flag now TRUE.");
    SetFlags(FireComplete,TRUE);
    End();
EarlyHallCrash:
    Log("Collapses the hall if somebody goes this way too early.");
    CheckFlags(HubWindow,FALSE,'Jojo');
    CheckFlags(HallCrash,TRUE,'Jojo');
    SetFlags(HallCrash,TRUE);
    ShakeCamera(888, 20000, 4444);
    SendUnrealEvent('HallCrashDisp');
    End();
HallCrash:
    Log("Bring it down, suck it down.");
    CheckFlags(FireComplete,FALSE,'Jojo');
    CheckFlags(HallCrash,TRUE,'Jojo');
    SetFlags(HallCrash,TRUE);
    ShakeCamera(888, 20000, 4444);
    SendUnrealEvent('HallCrashDisp');
    End();
BlahDoor:
    Log("The boring door, but it's got an explosion!");
    CheckFlags(FireComplete,FALSE,'Jojo');
    CheckFlags(BlahDoor,TRUE,'Jojo');
    SetFlags(BlahDoor,TRUE);
    CheckFlags(PathSelected,TRUE,'Jojo');
    SetFlags(PathSelected,TRUE);
    LockDoor('FenceDoorB', FALSE, TRUE);
    SendUnrealEvent('FenceDoorB');
    End();
StartYoEngines:
    Log("Teleport and run for the hills, yo.");
    CheckFlags(BlahDoor,FALSE,'Jojo');
    CheckFlags(TechRanAlready,TRUE,'Jojo');
    SetFlags(TechRanAlready,TRUE);
    ResetGoals(1);
    DisableMessages(TRUE, FALSE);
    Teleport(1, 'Adam_1450');
    Goal_Set(1,GOAL_MoveTo,9,,,,'schitzoone',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,8,,,,'schitzotwo',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,7,,,,'schitzothree',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,6,,,,'PreKyuss',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,5,,,,'schitzofive',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,4,,,,'Danny_0',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,3,,,,'Adam_400',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,2,,,,'PiotrTele',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Stop,1,,'BoatFocus','BoatFocus','PiotrTele','WaitCrAlFd0',FALSE,999999,,,);
    End();
SpecialDoor:
    Log("If Sam comes out of the fire room through the bestest of doors.  Sassy!");
    CheckFlags(FireComplete,FALSE,'Jojo');
    CheckFlags(SpecialDoor,TRUE,'Jojo');
    SetFlags(SpecialDoor,TRUE);
    CheckFlags(PathSelected,TRUE,'Jojo');
    SetFlags(PathSelected,TRUE);
    LockDoor('FenceDoorA', FALSE, TRUE);
    SendUnrealEvent('FenceDoorA');
    ResetGoals(1);
    DisableMessages(TRUE, FALSE);
    Teleport(1, 'RunRunRun');
    Goal_Default(1,GOAL_Guard,0,,,,'RunRunRun',,FALSE,,,,);
    Sleep(0.25);
    Goal_Set(1,GOAL_MoveTo,9,,,,'Adam_1300',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,8,,,,'Adam_900',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,7,,,,'Adam_700',,FALSE,,MOVE_JogAlert,,MOVE_WalkAlert);
    Goal_Set(1,GOAL_MoveTo,6,,,,'Adam_300',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,5,,,,'PiotrTele',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Stop,2,,'BoatFocus','BoatFocus','PiotrTele','WaitCrAlFd0',FALSE,999999,,,);
    End();
LeetDoor:
    Log("An even better than bestest door!  Extra 1337!!  ULTRA-SASSY!!!");
    CheckFlags(FireComplete,FALSE,'Jojo');
    CheckFlags(SpecialDoor,TRUE,'Jojo');
    SetFlags(SpecialDoor,TRUE);
    CheckFlags(PathSelected,TRUE,'Jojo');
    SetFlags(PathSelected,TRUE);
    ResetGoals(1);
    DisableMessages(TRUE, FALSE);
    Teleport(1, 'leettwo');
    Goal_Set(1,GOAL_MoveTo,9,,,,'Adam_1000',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,7,,,,'Adam_700',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,5,,,,'PiotrTele',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Stop,2,,'BoatFocus','BoatFocus','PiotrTele','WaitCrAlFd0',FALSE,999999,,,);
    End();
Done:
    Log("Piotr killed/unconscious.");
    SendPatternEvent('LambertAI','GetOut');
    End();
Kerplunk:
    Log("Under the sea...");
    DisableMessages(TRUE, TRUE);
    SetExclusivity(TRUE);
    SendPatternEvent('LambertAI','Over');
    End();
Nothingness:
    End();

}


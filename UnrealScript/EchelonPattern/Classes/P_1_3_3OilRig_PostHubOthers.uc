//=============================================================================
// P_1_3_3OilRig_PostHubOthers
//=============================================================================
class P_1_3_3OilRig_PostHubOthers extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\Gun.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int DaKitchen;
var int NotQuiteSassy;
var int TeleportDone;
var int WindowGunfirePlayedOnce;
var int WindowTriggered;


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
        if (P.name == 'EGeorgianSoldier12')
            Characters[1] = P.controller;
        if (P.name == 'EGeorgianSoldier13')
            Characters[2] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if (A.name == 'ESoundTrigger23')
            SoundActors[0] = A;
    }

    if (!bInit)
    {
    bInit=TRUE;
    DaKitchen=0;
    NotQuiteSassy=0;
    TeleportDone=0;
    WindowGunfirePlayedOnce=0;
    WindowTriggered=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
PostHub:
    Log("Rock on after the hub.");
    SendUnrealEvent('PostHubOthZoneAI');
    SetExclusivity(TRUE);
    SendPatternEvent('escort2v2AI','Tele');
    Teleport(1, 'Maynard_3500');
    Goal_Default(1,GOAL_Guard,0,,,,'Maynard_3500',,FALSE,,,,);
    SetFlags(TeleportDone,TRUE);
    ChangeGroupState('s_alert');
    Sleep(0.5);
    CheckFlags(NotQuiteSassy,TRUE,'BreakWindow');
    End();
SassyWindo:
    Log("Breaks the window");
    CheckFlags(DaKitchen,FALSE,'NotQuiteSassy');
BreakWindow:
    Log("Smashy-smashy.");
    CheckFlags(WindowGunfirePlayedOnce,TRUE,'Nothingness');
    SetFlags(WindowGunfirePlayedOnce,TRUE);
    SendUnrealEvent('SassyWindo');
	SoundActors[0].PlaySound(Sound'Gun.Play_AK47SingleShot', SLOT_SFX);
    Sleep(0.25);
	SoundActors[0].PlaySound(Sound'Gun.Play_AK47SingleShot', SLOT_SFX);
    Sleep(0.2);
	SoundActors[0].PlaySound(Sound'Gun.Play_A91ASingleShot', SLOT_SFX);
    Sleep(0.25);
	SoundActors[0].PlaySound(Sound'Gun.Play_AK47SingleShot', SLOT_SFX);
    Sleep(0.2);
	SoundActors[0].PlaySound(Sound'Gun.Play_A91ASingleShot', SLOT_SFX);
    End();
NotQuiteSassy:
    Log("For the window breaking AI triggered instead of EVolume triggered.");
    SetFlags(NotQuiteSassy,TRUE);
    End();
Window:
    Log("when Sam comes through the window");
    IgnoreAlarmStage(TRUE);
    CheckFlags(DaKitchen,FALSE,'Nothingness');
    Log("DaKitchen flag must be TRUE");
    CheckFlags(WindowTriggered,TRUE,'Nothingness');
    SetFlags(WindowTriggered,TRUE);
    CheckFlags(TeleportDone,FALSE,'Nothingness');
    SendPatternEvent('escort2v2AI','MachiDestructGuys');
    SendPatternEvent('Merctech2AI','Run');
    SendPatternEvent('ChopperFodder','Ready');
    SendUnrealEvent('WindowCineDisable');
    CinCamera(0, 'camerii', 'targe',);
    SetExclusivity(TRUE);
temp:
    Log("");
    Goal_Set(1,GOAL_Stop,9,,'PiotrDeux','PiotrDeux',,,FALSE,2,,,);
    WaitForGoal(1,GOAL_Stop,);
    Goal_Set(1,GOAL_MoveTo,8,,,,'gp2',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Guard,2,,,,'gp2',,FALSE,,,,);
    Sleep(2);
    CinCamera(1, , ,);
    SendUnrealEvent('WindowCineEnable');
temp2:
    Log("Are we seeing this or what?");
    SendPatternEvent('ChopperFodder','Panic');
    End();
ChopChop:
    Log("Resets exclusivity after chopper blows.");
    ChangeState(1,'s_alert');
    Goal_Set(1,GOAL_Action,9,,,,,'ReacStNmZZ0',FALSE,,,,);
    Sleep(1);
    WaitForGoal(1,GOAL_Action,'Patrol');
    Goal_Set(1,GOAL_MoveTo,9,,,,'adjunct',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Action,8,,,,,'ReacStAlFd2',FALSE,,,,);
    Goal_Set(1,GOAL_MoveTo,7,,,,'ApproachNode',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    WaitForGoal(1,GOAL_MoveTo,'Patrol');
    Jump('Patrol');
    End();
ChopChopTwo:
    Log("PostHubOther pattern if chopper destroyed early, which shouldn't really happen but anyway...");
    ChangeState(1,'s_alert');
    Teleport(1, 'adjunct');
    Goal_Set(1,GOAL_MoveTo,7,,,,'ApproachNode',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveTo,'Patrol');
    Jump('Patrol');
    End();
KitchenFlag:
    Log("Sets da kitchen flag.");
    SetFlags(DaKitchen,TRUE);
    End();
Nothingness:
    Log("Null.");
    End();
Patrol:
    Log("Sends the last guy scurrying.");
    ePawn(Characters[1].Pawn).Bark_Type = BARK_GroupScatter;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    SetExclusivity(FALSE);
    Goal_Default(1,GOAL_Patrol,9,,,,'Spock_0',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    End();
Exclu:
    Log("Resets last patrol dude exclusivity (guy on roof).");
    End();

}


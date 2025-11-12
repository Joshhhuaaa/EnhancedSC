//=============================================================================
// P_4_1_2_CEmb_FeirongGroup
//=============================================================================
class P_4_1_2_CEmb_FeirongGroup extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_1_2Voice.uax
#exec OBJ LOAD FILE=..\Sounds\Vehicules.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('EndGameOver');
            break;
        case AI_GRABBED:
            EventJump('EndGameOver');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('EndGameOver');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('EndGameOver');
            break;
        case AI_SEE_CHANGED_ACTOR:
            EventJump('EndGameOver');
            break;
        case AI_SEE_INTERROGATION:
            EventJump('EndGameOver');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('EndGameOver');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('EndGameOver');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('EndGameOver');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('EndGameOver');
            break;
        case AI_UNCONSCIOUS:
            EventJump('EndGameOver');
            break;
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
        if (P.name == 'EFeirong0')
            Characters[1] = P.controller;
        if (P.name == 'EChineseSoldier12')
            Characters[2] = P.controller;
        if (P.name == 'EChineseSoldier26')
            Characters[3] = P.controller;
        if (P.name == 'EChineseSoldier25')
            Characters[4] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if (A.name == 'EAnimatedObject0')
            SoundActors[0] = A;
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
FeirongConversationA:
    Log("Feirong has the first laser-mic-ed phone call here. Triggered by Sam.");
    CinCamera(0, 'CamCinPointA', 'CamCinFocusA',);
    Sleep(4);
    CinCamera(1, , ,);
    Sleep(8);
    LaserMicSession(0,'WindowMover',0,'');
    Talk(Sound'S4_1_2Voice.Play_41_20_01', 1, , TRUE, 100);
    Close();
    LaserMicSession(1,,80,'FirstLaserMicDone');
    SendPatternEvent('LambertBogus','LaserMicFailureB');
FeirongStairs:
    Log("Feirong walks down the stairs and talks to a soldier. Triggered by Sam.");
    Goal_Default(1,GOAL_Guard,9,,,,'WaitForLimo',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(2,GOAL_Guard,9,,'LastPatrolFocus01',,'FeirongGuardAtGate',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_MoveTo,9,,,,'StairsA',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_MoveTo,8,,,,'FeirongTalkStart',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_MoveTo,7,,,,'FeirongGuardAtGate',,TRUE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Sleep(2);
    Goal_Set(1,GOAL_MoveTo,9,,,,'StairsA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,8,,,,'WaitForLimo',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(2,GOAL_MoveTo,);
	SoundActors[0].    PlaySound(Sound'Vehicules.Play_ChineseVanStart', SLOT_SFX);
    SendUnrealEvent('limo');
    LockDoor('EntraceDoorA', FALSE, TRUE);
    LockDoor('EntraceDoorB', FALSE, TRUE);
    Teleport(2, 'SoldierTeleport');
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveTo,9,,,,'FeirongTalkStart',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    Teleport(1, 'FeirongTeleportA');
    ResetGoals(1);
    Sleep(2);
	SoundActors[0].    PlaySound(Sound'Vehicules.Play_CadillacIdle', SLOT_SFX);
    End();
FeirongConversationB:
    Log("Feirong gets in the limousine and has the second conversation on the way to the gate. Triggered by Feirong.");
    Sleep(1);
    Goal_Set(1,GOAL_Action,9,,'LimoFocusForClimbInAnim','LimoFocusForClimbInAnim','WaitForLimo','LimoStNmIn0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(0.2);
    SendUnrealEvent('limo');
    WaitForGoal(1,GOAL_Action,);
    Teleport(1, 'FeirongTeleport');
    LockDoor('EntraceDoorB', FALSE, FALSE);
    LockDoor('EntraceDoorA', FALSE, FALSE);
	SoundActors[0].    PlaySound(Sound'Vehicules.Stop_CadillacIdle', SLOT_SFX);
	SoundActors[0].    PlaySound(Sound'Vehicules.Play_ChineseVanStart', SLOT_SFX);
    SendUnrealEvent('limo');
    Sleep(2);
    SendPatternEvent('LimoCheckLoop','LimoLoop');
    SetFlags(V4_1_2ChineseEmbassy(Level.VarObject).LimoAtFrontGate,TRUE);
	SoundActors[0].    PlaySound(Sound'Vehicules.Play_CadillacIdle', SLOT_SFX);
    Sleep(3);
    LaserMicSession(0,'LaserMicLimo',0,'');
    Talk(Sound'S4_1_2Voice.Play_41_35_01', 3, , TRUE, 34);
    Talk(Sound'S4_1_2Voice.Play_41_35_02', 3, , TRUE, 33);
    Talk(Sound'S4_1_2Voice.Play_41_35_03', 3, , TRUE, 33);
    LaserMicSession(1,,50,'MainGateCheck');
    SendPatternEvent('LambertBogus','LaserMicFailure');
    End();
MainGateCheck:
    Log("Gate soldier comes out and talks to limousine driver then goes back in the guardhouse. Triggered by Feirong.");
    SetFlags(V4_1_2ChineseEmbassy(Level.VarObject).LaserMicCompleted,TRUE);
    SendPatternEvent('LambertBogus','FeirongSecondLamCall');
    Goal_Default(3,GOAL_Guard,8,,'LimoFocus',,'GateGuardC',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    SetExclusivity(FALSE);
    DisableMessages(TRUE, FALSE);
    End();
MainGateOpen:
    Log("The gate opens and the limousine drives out. Triggered by gate guard.");
    SendUnrealEvent('MainGate');
    SendPatternEvent('Frances','FrancesSpawn');
    Sleep(4);
	SoundActors[0].    PlaySound(Sound'Vehicules.Stop_CadillacIdle', SLOT_SFX);
	SoundActors[0].    PlaySound(Sound'Vehicules.Play_ChineseVanStart', SLOT_SFX);
    SendUnrealEvent('limo');
    SetFlags(V4_1_2ChineseEmbassy(Level.VarObject).LimoAtFrontGate,FALSE);
    Goal_Default(4,GOAL_Patrol,9,,,,'ECS412017_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(3);
    SendUnrealEvent('MainGate');
    IgnoreAlarmStage(TRUE);
    Sleep(1);
    SendUnrealEvent('limo');
    ResetGoals(2);
    Goal_Default(2,GOAL_Patrol,9,,,,'ECS412019_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    SetFlags(V4_1_2ChineseEmbassy(Level.VarObject).LastMikDone,TRUE);
    Log("THE FLAG HAS BEEN SET!!!!!!!!");
    SetExclusivity(FALSE);
    End();
FirstLaserMicDone:
    Log("FirstLaserMicDone");
    SendPatternEvent('LambertBogus','FeirongFirstLamCall');
    Jump('FeirongStairs');
    End();
EndGameOver:
    Log("This plays when Fisher messes up and fails the mission. Triggered by Sam.");
    SetExclusivity(TRUE);
    Log("1");
    CheckFlags(V4_1_2ChineseEmbassy(Level.VarObject).LastMikDone,TRUE,'OK');
    Log("2");
    DisableMessages(TRUE, TRUE);
    Log("3");
    IgnoreAlarmStage(TRUE);
    Log("4");
    ResetGoals(1);
    Log("5");
    ResetGoals(2);
    Log("6");
    ResetGoals(4);
    Log("7");
    Goal_Set(2,GOAL_Attack,9,,'PLAYER','PLAYER',,,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Attack,9,,'PLAYER','PLAYER',,,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(4,GOAL_Attack,9,,'PLAYER','PLAYER',,,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Log("8");
    ePawn(Characters[2].Pawn).Bark_Type = BARK_SeePlayer;
    Talk(ePawn(Characters[2].Pawn).Sounds_Barks, 2, 0, false);
    Log("9");
    Sleep(2);
    Log("10");
    SendPatternEvent('LambertBogus','LaserMicFailure');
OK:
    End();

}


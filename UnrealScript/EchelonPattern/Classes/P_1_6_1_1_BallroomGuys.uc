//=============================================================================
// P_1_6_1_1_BallroomGuys
//=============================================================================
class P_1_6_1_1_BallroomGuys extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_4_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Conv;


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
        if (P.name == 'spetsnaz16')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
            EAIController(Characters[1]).bBlockDetection = true;
            EAIController(Characters[1]).bWasFound = true;
        }
        if (P.name == 'spetsnaz15')
        {
            Characters[2] = P.controller;
            EAIController(Characters[2]).bAllowKnockout = true;
            EAIController(Characters[2]).bBlockDetection = true;
            EAIController(Characters[2]).bWasFound = true;
        }
        if (P.name == 'spetsnaz14')
        {
            Characters[3] = P.controller;
            EAIController(Characters[3]).bAllowKnockout = true;
            EAIController(Characters[3]).bBlockDetection = true;
            EAIController(Characters[3]).bWasFound = true;
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    Conv=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
OptionalConv:
    Log("OptionalConv");
    CheckFlags(Conv,TRUE,'End');
    DisableMessages(TRUE, TRUE);
    SetFlags(Conv,TRUE);
    Goal_Set(1,GOAL_Action,9,,,,,'TalkStNmBB0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_38_01', 1, , TRUE, 0);
    Goal_Set(2,GOAL_Action,9,,,,,'LstnStNmBB0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_38_02', 2, , TRUE, 0);
    Goal_Set(1,GOAL_Action,9,,,,,'LstnStNmCC0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_38_03', 1, , TRUE, 0);
    Goal_Set(2,GOAL_Action,9,,,,,'TalkStNmAA0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_38_04', 2, , TRUE, 0);
    DisableMessages(FALSE, FALSE);
    End();
MilestoneBallroom:
    Log("MilestoneBallroom");
    ToggleGroupAI(TRUE, 'BallroomFight', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    Sleep(1.50);
    LockDoor('doorforcedcombat', FALSE, TRUE);
    ResetGoals(1);
    ResetGoals(2);
    ResetGoals(3);
    ChangeGroupState('s_alert');
    Teleport(1, 'LadPathB');
    Teleport(2, 'BallA');
    Goal_Set(1,GOAL_MoveTo,9,,,,'RushOneBall',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_MoveAndAttack,8,,,,'RushAttackOneBall',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Attack,7,,'PLAYER','PLAYER','RushAttackOneBall',,TRUE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,9,,,,'RushTwoBall',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_MoveAndAttack,8,,,,'RushAttackTwoBall',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(2,GOAL_Attack,7,,'PLAYER','PLAYER','RushAttackTwoBall',,TRUE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_MoveAndAttack,9,,,,'GrenadeSpot',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_ThrowGrenade,8,,,,'grenadeball',,FALSE,1.3,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Attack,7,,'PLAYER','PLAYER','GrenadeSpot',,TRUE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(10);
    ePawn(Characters[3].Pawn).Bark_Type = BARK_ShootHim;
    Talk(ePawn(Characters[3].Pawn).Sounds_Barks, 3, 0, false);
    Sleep(15);
    SetExclusivity(FALSE);
    ResetGoals(1);
    ResetGoals(2);
    ResetGoals(3);
    ePawn(Characters[3].Pawn).Bark_Type = BARK_GroupScatter;
    Talk(ePawn(Characters[3].Pawn).Sounds_Barks, 3, 0, false);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'BallFinalSweepOne',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,9,,'BallFocusA','BallFocusA','BallFinalSweepOne',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,,'BallFinalSweepTwo',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,8,,'BallFocusB','BallFocusB','BallFinalSweepTwo',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_MoveAndAttack,9,,,,'BallFinalSweepThree',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Attack,8,,'BallFocusB','BallFocusB','BallFinalSweepThree',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(20);
    SendPatternEvent('MasseGroup','NikolaiSearch');
    ePawn(Characters[3].Pawn).Bark_Type = BARK_LostPlayer;
    Talk(ePawn(Characters[3].Pawn).Sounds_Barks, 3, 0, false);
    ResetGoals(1);
    ResetGoals(2);
    ResetGoals(3);
    ChangeGroupState('s_default');
    ChangeGroupState('s_investigate');
    Goal_Set(1,GOAL_MoveTo,9,,,,'BallroomSearchingA',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(1,GOAL_Search,8,,,,'BallroomSearchingA',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(2,GOAL_MoveTo,9,,,,'BallroomSearchingB',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(2,GOAL_Search,8,,,,'BallroomSearchingB',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(3,GOAL_MoveTo,9,,,,'BallroomSearchingC',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(3,GOAL_Search,8,,,,'BallroomSearchingC',,FALSE,,MOVE_Search,,MOVE_Search);
End:
    End();

}

defaultproperties
{
}

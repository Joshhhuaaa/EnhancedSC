//=============================================================================
// P_1_7_1_1_NVCRoom
//=============================================================================
class P_1_7_1_1_NVCRoom extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int TelDone;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('GoFalseNVCRoom');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('GoFalseNVCRoom');
            break;
        case AI_SEE_INTERROGATION:
            EventJump('GoFalseNVCRoom');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('GoFalseNVCRoom');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('GoFalseNVCRoom');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('GoFalseNVCRoom');
            break;
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
        if(P.name == 'EFalseRussianSoldier3')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz22')
            Characters[2] = P.controller;
        if(P.name == 'spetsnaz21')
            Characters[3] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    TelDone=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
MilestoneNVCRoom:
    Log("MilestoneNVCRoom");
    CheckFlags(V1_7_1_1VselkaInfiltration(Level.VarObject).ContDoorsOpen,FALSE,'SkipCloseDoors');
    Log("Closes the Control room door if its open, and skip if it's already closed because of a previous alarm");
    SendUnrealEvent('ControlRoomDoors');
    SetFlags(V1_7_1_1VselkaInfiltration(Level.VarObject).ContDoorsOpen,FALSE);
    SetFlags(V1_7_1_1VselkaInfiltration(Level.VarObject).DisableDoor,TRUE);
SkipCloseDoors:
    Log("SkipCloseDoors");
    Goal_Set(1,GOAL_MoveTo,9,,,,'FloorSecond',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(2);
    Goal_Set(2,GOAL_MoveTo,9,,,,'StairsPApathG',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_MoveTo,9,,,,'StairsPApathH',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(3,GOAL_MoveTo,);
    Teleport(1, 'OtherPathFourthC');
    Teleport(2, 'NVtelA');
    Teleport(3, 'NVtelB');
    SetFlags(TelDone,TRUE);
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'NVposC',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Attack,8,,'NVroomFokus','NVroomFokus','NVposC',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Patrol,1,,,,'PatrolFourthFloorA',,FALSE,,MOVE_Search,,MOVE_Search);
    Sleep(10);
    Goal_Set(2,GOAL_MoveAndAttack,7,,,,'NVposA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_Attack,6,,'NVroomFokus','NVroomFokus','NVposA',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(2,GOAL_Patrol,1,,,,'OtherPathFourthA',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(3,GOAL_MoveAndAttack,9,,,,'NVposB',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_Attack,8,,'NVroomFokus','NVroomFokus','NVposB',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(3,GOAL_Patrol,1,,,,'DormPathE',,FALSE,,MOVE_Search,,MOVE_Search);
    Sleep(14);
    SetFlags(V1_7_1_1VselkaInfiltration(Level.VarObject).DisableDoor,TRUE);
    CheckFlags(V1_7_1_1VselkaInfiltration(Level.VarObject).ContDoorsOpen,TRUE,'NVattackANVCRoom');
    SendUnrealEvent('ControlRoomDoors');
    SetFlags(V1_7_1_1VselkaInfiltration(Level.VarObject).ContDoorsOpen,TRUE);
NVattackANVCRoom:
    Log("NVattackANVCRoom");
    Goal_Set(1,GOAL_Action,9,,,,,'SignStAlFd0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,,'MoveAndAttackTwo',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_MoveAndAttack,8,,,,'MoveAndAttackFour',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_Attack,7,,,,'MoveAndAttackFour',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Sleep(2);
    ResetGoals(3);
    Goal_Set(3,GOAL_MoveAndAttack,9,,,,'MoveAndAttackThree',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(3,GOAL_MoveAndAttack,8,,,,'MoveAndAttackFive',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(3,GOAL_Attack,7,,,,'MoveAndAttackFive',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Sleep(1);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'MoveAndAttackOne',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(1,GOAL_Attack,8,,'NVroomFokus','NVroomFokus','MoveAndAttackOne',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Sleep(14);
    ePawn(Characters[1].Pawn).Bark_Type = BARK_GroupScatter;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    ResetGroupGoals();
    ChangeGroupState('s_default');
    ChangeGroupState('s_investigate');
    SetExclusivity(FALSE);
    End();
CSNVCRoom:
    Log("CSNVCRoom");
    StartAlarm('DecompAlarm',0);
    SendUnrealEvent('SubWareDoors');
    Sleep(1.5);
    ToggleGroupAI(TRUE, 'NVCRoom', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    Teleport(1, 'PreWareNodeA');
    Teleport(2, 'FirstWareNodeA');
    Teleport(3, 'WarehousePathA');
    Goal_Set(1,GOAL_MoveAndAttack,9,,'LalalalFocusA','LalalalFocusA','FloorFirst',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Attack,8,,,,'FloorThird',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_Guard,8,,'stairwellbottomdoor','stairwellbottomdoor','AfterPiss',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_Attack,8,,'LalalalFocusA','LalalalFocusA','PostPissPathC',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    WaitForGoal(1,GOAL_MoveAndAttack,);
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,,'FloorSecond',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(1);
    Goal_Set(3,GOAL_MoveAndAttack,9,,,,'FloorSecond',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();
GoFalseNVCRoom:
    Log("GoFalseNVCRoom");
    CheckFlags(TelDone,FALSE,'End');
    SetExclusivity(FALSE);
    End();
TelNVCRoom:
    Log("TelNVCRoom");
    CheckIfIsUnconscious(1,'TelNVCRoomB');
    Teleport(1, 'TelNodeV');
    KillNPC(1, FALSE, FALSE);
TelNVCRoomB:
    Log("TelNVCRoomB");
    CheckIfIsUnconscious(2,'TelNVCRoomC');
    Teleport(2, 'TelNodeW');
    KillNPC(2, FALSE, FALSE);
TelNVCRoomC:
    Log("TelNVCRoomC");
    CheckIfIsUnconscious(3,'End');
    Teleport(3, 'TelNodeX');
    KillNPC(3, FALSE, FALSE);
End:
    End();

}

defaultproperties
{
}

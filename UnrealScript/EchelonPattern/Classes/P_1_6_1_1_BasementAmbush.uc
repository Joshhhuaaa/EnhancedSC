//=============================================================================
// P_1_6_1_1_BasementAmbush
//=============================================================================
class P_1_6_1_1_BasementAmbush extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_4_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_HEAR_RICOCHET:
            EventJump('SeePlayer');
            break;
        case AI_SEE_INTERROGATION:
            EventJump('SeePlayer');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('SeePlayer');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('SeePlayer');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('SeePlayer');
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
        if(P.name == 'spetsnaz4')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz6')
            Characters[2] = P.controller;
        if(P.name == 'spetsnaz5')
            Characters[3] = P.controller;
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
MilestoneBasementAmbush:
    Log("MilestoneBasementAmbush");
    ToggleGroupAI(TRUE, 'GroupBasementAmbush', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    CheckFlags(V1_6_1_1KolaCell(Level.VarObject).BigDoorOutOpen,TRUE,'BasementCarry');
    SendUnrealEvent('BigDoorsTestOut');
    SendUnrealEvent('OutDoorLight');
    SetFlags(V1_6_1_1KolaCell(Level.VarObject).BigDoorOutOpen,TRUE);
    SendPatternEvent('BeforeLast','BigDoorOutSound');
BasementCarry:
    Log("BasementCarry");
    CheckFlags(V1_6_1_1KolaCell(Level.VarObject).BigDoorInOpen,TRUE,'BasementCarryB');
    SendUnrealEvent('BigDoorsTest');
    SendUnrealEvent('InDoorLight');
    SetFlags(V1_6_1_1KolaCell(Level.VarObject).BigDoorInOpen,TRUE);
    SendPatternEvent('Last','BigDoorInSound');
BasementCarryB:
    Log("BasementCarryB");
    LockDoor('ambushbehinddoor', FALSE, TRUE);
    Goal_Set(2,GOAL_InteractWith,9,,,,'BasementLights',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(2,GOAL_InteractWith,);
    Teleport(1, 'TelHimInBAckA');
    Teleport(2, 'TelFrontGuyOne');
    Teleport(3, 'TelFrontGuyTwo');
    ChangeGroupState('s_alert');
    JumpRandom('AttackRandomOne', 0.33, 'AttackRandomTwo', 0.67, 'AttackRandomThree', 1.00, , , , ); 
    End();
AttackRandomOne:
    Log("AttackRandomOne");
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'BackGuyAttack',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,8,,'FocusBack','FocusBack','BackGuyAttack',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,,'FrontGuyAttackOne',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,8,,'FocusTwo','FocusTwo','FrontGuyAttackOne',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_MoveAndAttack,9,,,,'FrontGuyAttackTwo',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Attack,8,,'FocusOne','FocusOne','FrontGuyAttackTwo',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(10);
    ePawn(Characters[1].Pawn).Bark_Type = BARK_LostPlayer;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    Sleep(5);
    Jump('FailedAttack');
    End();
AttackRandomTwo:
    Log("AttackRandomTwo");
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'BasementNodeOne',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,8,,'focusflasherpatrolA','focusflasherpatrolA','BasementNodeOne',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,,'BasementNodeTwo',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,8,,'FocusOne','FocusOne','BasementNodeTwo',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_MoveAndAttack,9,,,,'FrontGuyAttackTwo',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Attack,8,,'FocusTwo','FocusTwo','FrontGuyAttackTwo',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(10);
    ePawn(Characters[1].Pawn).Bark_Type = BARK_LostPlayer;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    Sleep(5);
    Jump('FailedAttack');
    End();
AttackRandomThree:
    Log("AttackRandomThree");
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'BasementNodeOne',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,8,,'focusflasherpatrolA','focusflasherpatrolA','BasementNodeOne',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,,'FrontGuyAttackOne',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,8,,'ConversFoc','ConversFoc','FrontGuyAttackOne',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_MoveAndAttack,9,,,,'BasementNodeTwo',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Attack,8,,'FocusOne','FocusOne','BasementNodeTwo',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(10);
    ePawn(Characters[1].Pawn).Bark_Type = BARK_LostPlayer;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    Sleep(5);
    Jump('FailedAttack');
    End();
FailedAttack:
    Log("FailedAttack");
    ePawn(Characters[1].Pawn).Bark_Type = BARK_SearchFailedPlayer;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    SetExclusivity(FALSE);
    ResetGoals(1);
    ResetGoals(2);
    ResetGoals(3);
    ChangeGroupState('s_default');
    Goal_Set(1,GOAL_MoveTo,9,,,,'PostForcedAttackBack',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_Guard,8,,'ConversFoc',,'PostForcedAttackBack',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Patrol,1,,,,'BasePAttE',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,9,,,,'PostForcedAttackFrontTwo',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_Guard,8,,'ConversFoc',,'PostForcedAttackFrontTwo',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(2,GOAL_Patrol,1,,,,'BasePAttF',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_MoveTo,9,,,,'PostForcedAttackFrontOne',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(3,GOAL_Guard,8,,'ConversFoc',,'PostForcedAttackFrontOne',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(3,GOAL_Patrol,1,,,,'FlasherOneA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(3,GOAL_MoveTo,'afterconversation');
    WaitForGoal(2,GOAL_MoveTo,'afterconversation');
    WaitForGoal(1,GOAL_MoveTo,'afterconversation');
    Sleep(1);
    Goal_Set(2,GOAL_Action,9,,,,,'TalkStNmBB0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_36_01', 2, , TRUE, 0);
    Goal_Set(1,GOAL_Action,9,,,,,'LstnStNmBB0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_36_02', 1, , TRUE, 0);
    Goal_Set(2,GOAL_Action,9,,,,,'TalkStNmCC0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_36_03', 2, , TRUE, 0);
    Goal_Set(3,GOAL_Action,9,,,,,'TalkStNmAA0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_36_04', 3, , TRUE, 0);
    Goal_Set(1,GOAL_Action,9,,,,,'LstnStNmCC0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_36_05', 1, , TRUE, 0);
    Goal_Set(3,GOAL_Action,9,,,,,'LstnStNmBB0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_36_06', 3, , TRUE, 0);
    Goal_Set(2,GOAL_Action,9,,,,,'TalkStNmAA0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_36_07', 2, , TRUE, 0);
    Goal_Set(1,GOAL_Action,9,,,,,'LstnStNmBB0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_36_08', 1, , TRUE, 0);
    Goal_Set(3,GOAL_Action,9,,,,,'TalkStNmCC0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_36_09', 3, , TRUE, 0);
    Goal_Set(1,GOAL_Action,9,,,,,'LstnStNmBB0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_36_10', 1, , TRUE, 0);
    Goal_Set(2,GOAL_Action,9,,,,,'TalkStNmBB0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_36_11', 2, , TRUE, 0);
    Sleep(1);
    ePawn(Characters[1].Pawn).Bark_Type = BARK_CombArea;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
afterconversation:
    Log("afterconversation");
    ResetGoals(1);
    ResetGoals(2);
    ResetGoals(3);
    ChangeGroupState('s_investigate');
    Goal_Set(1,GOAL_MoveTo,9,,,,'BasePAttE',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,8,,,,'BasePAttE',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,9,,,,'BasePAttF',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Patrol,8,,,,'BasePAttF',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_MoveTo,9,,,,'FlasherOneA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(3,GOAL_Patrol,8,,,,'FlasherOneA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
SeePlayer:
    Log("SeePlayer");
    SetExclusivity(FALSE);
    End();
Tel:
    Log("Tel");
    CheckIfIsUnconscious(1,'TelB');
    Teleport(1, 'BasGarbageC');
    KillNPC(1, FALSE, TRUE);
TelB:
    Log("TelB");
    CheckIfIsUnconscious(2,'TelC');
    Teleport(2, 'BasGarbageB');
    KillNPC(2, FALSE, TRUE);
TelC:
    Log("TelC");
    CheckIfIsUnconscious(3,'End');
    Teleport(3, 'BasGarbageA');
    KillNPC(3, FALSE, TRUE);
End:
    End();

}

defaultproperties
{
}

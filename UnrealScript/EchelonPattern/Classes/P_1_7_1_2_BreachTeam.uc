//=============================================================================
// P_1_7_1_2_BreachTeam
//=============================================================================
class P_1_7_1_2_BreachTeam extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



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
        if (P.name == 'EFalseRussianSoldier7')
            Characters[1] = P.controller;
        if (P.name == 'spetsnaz26')
            Characters[2] = P.controller;
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
MilestoneBreachTeam:
    Log("MilestoneBreachTeam");
    ToggleGroupAI(TRUE, 'BreachTeam', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    Teleport(1, 'BreachTeamTelB');
    Teleport(2, 'BreachTeamTelA');
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'BreachTeamTelA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Attack,8,,'AttackPoint','PLAYER','BreachTeamTelA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Guard,1,,'AlaunchNodeB','AlaunchNodeB','AlaunchNodeA',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,,'GreNodeA',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_ThrowGrenade,8,,,,'GreT',,FALSE,0.5,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_Attack,7,,'GreT','PLAYER','GreNodeA',,TRUE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(2,GOAL_Patrol,1,,,,'PreContA',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Sleep(16);
GoInBreachTeam:
    Log("GoInBreachTeam");
    ePawn(Characters[1].Pawn).Bark_Type = BARK_ShootHim;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'AlaunchNodeA',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(1,GOAL_Attack,8,,'AlaunchNodeB','AlaunchNodeB','AlaunchNodeA',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,,'PreContAfoc',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_Attack,8,,'PreContA','PreContA','PreContAfoc',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Sleep(12);
GoGuardBreachTeam:
    Log("GoGuardBreachTeam");
    ePawn(Characters[1].Pawn).Bark_Type = BARK_LostPlayer;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    ResetGroupGoals();
    SetExclusivity(FALSE);
    ChangeGroupState('s_investigate');
    End();

}

defaultproperties
{
}

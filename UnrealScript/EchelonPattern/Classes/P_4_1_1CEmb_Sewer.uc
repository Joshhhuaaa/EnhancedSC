//=============================================================================
// P_4_1_1CEmb_Sewer
//=============================================================================
class P_4_1_1CEmb_Sewer extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_1_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('CheckIfDead');
            break;
        case AI_UNCONSCIOUS:
            EventJump('CheckIfDead');
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
        if (P.name == 'EChineseSoldier10')
            Characters[1] = P.controller;
        if (P.name == 'EChineseSoldier11')
            Characters[2] = P.controller;
        if (P.name == 'EChineseSoldier12')
            Characters[3] = P.controller;
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
SewerPatrol:
    Log("Sewer Patrol Starts");
    Goal_Default(1,GOAL_Guard,9,,'SoldierChat01Focus01',,'SoldierChat03',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(2,GOAL_Guard,9,,'SoldierChat01Focus01',,'SoldierChat01',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(3,GOAL_Guard,9,,'SoldierChat01Focus01',,'SoldierChat02',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Talk(Sound'S4_1_1Voice.Play_41_12_01', 1, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_02', 2, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_03', 1, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_04', 2, , TRUE, 0);
EndOfFirstSpeech:
    Log("When the first guard speech ends");
    Goal_Set(1,GOAL_MoveTo,9,,,,'SoldierChat2Node01',,TRUE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Guard,8,,'LookNervouslyA',,'LookNervouslyA',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Talk(Sound'S4_1_1Voice.Play_41_12_05', 1, , TRUE, 0);
    Goal_Set(2,GOAL_MoveTo,9,,,,'SoldierChat2Node02',,TRUE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(2,GOAL_Guard,8,,'LookNervouslyA',,'SoldierChat2Node02',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Talk(Sound'S4_1_1Voice.Play_41_12_06', 2, , TRUE, 0);
    Goal_Set(3,GOAL_MoveTo,9,,,,'CheckPointA',,TRUE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Talk(Sound'S4_1_1Voice.Play_41_12_07', 3, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_08', 1, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_09', 2, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_10', 3, , TRUE, 0);
    Close();
    WaitForGoal(3,GOAL_MoveTo,);
    ChangeState(3,'s_investigate');
    Goal_Set(3,GOAL_Guard,9,,'LookNervouslyA',,'CheckPointA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(3);
    ResetGoals(3);
    Goal_Set(3,GOAL_MoveTo,9,,,,'Soldier3PatrolCheck01',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(3,GOAL_MoveTo,);
    Goal_Set(3,GOAL_Stop,9,,'Soldier3PatrolCheckFocus01',,'Soldier3PatrolCheck01',,FALSE,3,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_Stop,8,,'Soldier3PatrolCheckFocus02',,'Soldier3PatrolCheck01',,FALSE,3,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_MoveTo,7,,,,'SoldierChat2Node03',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(3,GOAL_MoveTo,);
    Goal_Default(3,GOAL_Guard,9,,'SoldierChat2Focus01',,'SoldierChat2Node03',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    ResetGroupGoals();
    ChangeState(3,'s_default');
    Goal_Set(1,GOAL_MoveTo,9,,,,'SoldierChat3Node01',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Guard,8,,'SoldierChat3Focus01',,'SoldierChat3Node01',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Sleep(1.5);
    Goal_Set(2,GOAL_MoveTo,9,,,,'SoldierChat3Node02',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(2,GOAL_Guard,8,,'SoldierChat3Focus01',,'SoldierChat3Node02',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Sleep(2);
    Goal_Set(3,GOAL_MoveTo,9,,'SoldierChat3Focus01',,'SoldierChat3Node03',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(3,GOAL_Guard,8,,'SoldierChat3Focus01',,'SoldierChat3Node03',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Talk(Sound'S4_1_1Voice.Play_41_12_11', 1, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_12', 2, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_13', 1, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_14', 2, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_15', 3, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_16', 1, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_17', 2, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_18', 1, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_19', 3, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_20', 1, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_21', 3, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_22', 1, , TRUE, 0);
    Close();
    ResetGoals(3);
    ChangeState(3,'s_investigate');
    Goal_Set(3,GOAL_MoveTo,9,,,,'ECS411016_200',,TRUE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_MoveTo,8,,,,'ECS411016_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_Stop,7,,,,'ECS411016_0',,FALSE,6,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(3,GOAL_Stop,);
    ResetGoals(3);
    ChangeState(3,'s_default');
    Goal_Set(3,GOAL_MoveTo,9,,,,'SoldierChat3Node03',,TRUE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(3,GOAL_MoveTo,);
    Goal_Default(3,GOAL_Guard,9,,'SoldierChat3Focus01',,'SoldierChat3Node03',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Talk(Sound'S4_1_1Voice.Play_41_12_23', 3, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_24', 2, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_25', 1, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_26', 1, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_27', 2, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_28', 1, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_29', 3, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_30', 1, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_31', 2, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_32', 3, , TRUE, 0);
    Talk(Sound'S4_1_1Voice.Play_41_12_33', 1, , TRUE, 0);
    Close();
    ResetGroupGoals();
    Goal_Default(2,GOAL_Patrol,9,,,,'ECS411015_0',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Sleep(1.5);
    Goal_Set(1,GOAL_MoveTo,9,,,,'ECS411016_800',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Guard,8,,'LookSHereA',,'ECS411015_400',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Sleep(1.5);
    Goal_Default(3,GOAL_Patrol,9,,,,'ECS411016_900',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();
CheckIfDead:
    Log("Checks if one of the 3 guards is dead, and if yes, gives their default patrol");
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveTo,9,,,,'ECS411016_900',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Patrol,9,,,,'ECS411016_900',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_MoveTo,9,,,,'ECS411015_0',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(2,GOAL_Patrol,9,,,,'ECS411015_0',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(3,GOAL_MoveTo,9,,,,'ECS411015_400',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(3,GOAL_Guard,9,,'LookSHereA',,'ECS411015_400',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();

}


//=============================================================================
// P_4_3_1_HallTurretAttackA
//=============================================================================
class P_4_3_1_HallTurretAttackA extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_3_1Voice.uax

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
        if (P.name == 'EChineseSoldier15')
            Characters[1] = P.controller;
        if (P.name == 'EChineseSoldier16')
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
HallTurretAttackA:
    Log("HallTurretAttackA");
    Teleport(1, 'HallSquadASpawn2');
    Teleport(2, 'HallSquadASpawn1');
    ResetGroupGoals();
    Goal_Default(1,GOAL_Guard,9,,'SquadAFocus',,'SquadAPatrolnode02',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(2,GOAL_Guard,9,,'SquadAFocus',,'SquadAPatrolnode01',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_Stop,9,,,,'HallSquadASpawn2',,FALSE,5,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_Stop,9,,,,'HallSquadASpawn1',,FALSE,5,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Talk(Sound'S4_3_1Voice.Play_43_27_01', 1, , TRUE, 0);
    Talk(Sound'S4_3_1Voice.Play_43_27_02', 2, , TRUE, 0);
    Talk(Sound'S4_3_1Voice.Play_43_27_03', 1, , TRUE, 0);
    Talk(Sound'S4_3_1Voice.Play_43_27_04', 2, , TRUE, 0);
    Talk(Sound'S4_3_1Voice.Play_43_27_05', 1, , TRUE, 0);
    Talk(Sound'S4_3_1Voice.Play_43_27_06', 2, , TRUE, 0);
    Talk(Sound'S4_3_1Voice.Play_43_27_07', 1, , TRUE, 0);
    Talk(Sound'S4_3_1Voice.Play_43_27_08', 2, , TRUE, 0);
    Close();
    End();

}


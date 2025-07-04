//=============================================================================
// P_1_7_1_2_CargoGuys
//=============================================================================
class P_1_7_1_2_CargoGuys extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_1_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



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
        if(P.name == 'EFalseRussianSoldier3')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz7')
            Characters[2] = P.controller;
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
MilestoneCargoGuys:
    Log("MilestoneCargoGuys");
    ToggleGroupAI(TRUE, 'CargoGuys', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    SetExclusivity(FALSE);
    Goal_Set(1,GOAL_MoveTo,9,,,,'WhitePatrolsAfoc',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,7,,,,'WhitePatrolsAfoc',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
ConversateCargoGuys:
    Log("ConversateCargoGuys");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'CargoPatD',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Guard,8,,'Jonny','Jonny','CargoPatD',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,7,,,,'CargoPatD',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,'End');
    Talk(Sound'S3_1_1Voice.Play_31_06_02', 2, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_06_03', 1, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_06_04', 2, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_06_05', 1, , TRUE, 0);
    ResetGoals(1);
    End();
TelCargoGuys:
    Log("TelCargoGuys");
    CheckIfIsUnconscious(1,'TelBCargoGuys');
    Teleport(1, 'TelNodeI');
    KillNPC(1, FALSE, FALSE);
TelBCargoGuys:
    Log("TelBCargoGuys");
    CheckIfIsUnconscious(2,'End');
    Teleport(2, 'TelNodeJ');
    KillNPC(2, FALSE, FALSE);
End:
    End();

}

defaultproperties
{
}

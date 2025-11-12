//=============================================================================
// P_1_7_1_1_HellsKitchen
//=============================================================================
class P_1_7_1_1_HellsKitchen extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_1_1Voice.uax

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
        if (P.name == 'spetsnaz11')
            Characters[1] = P.controller;
        if (P.name == 'spetsnaz10')
            Characters[2] = P.controller;
        if (P.name == 'spetsnaz12')
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
MilestoneHellsKitchen:
    Log("MilestoneHellsKitchen");
    ToggleGroupAI(TRUE, 'HellsKitchen', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    Goal_Set(1,GOAL_Wait,9,,,,'ChairUp',,FALSE,,MOVE_Sit,,MOVE_Sit);
    Goal_Default(1,GOAL_Patrol,1,,,,'SeeBobrov',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_Wait,9,,,,'ChairRight',,FALSE,,MOVE_Sit,,MOVE_Sit);
    Goal_Default(2,GOAL_Patrol,1,,,,'KitdUpPathC',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_Wait,9,,,,'ChairDown',,FALSE,,MOVE_Sit,,MOVE_Sit);
    Goal_Default(3,GOAL_Patrol,1,,,,'KitdDownPathC',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(8);
    Close();
    Talk(Sound'S3_1_1Voice.Play_31_15_01', 1, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_15_02', 2, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_15_03', 3, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_15_04', 1, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_15_05', 3, , TRUE, 0);
    Talk(Sound'S3_1_1Voice.Play_31_15_07', 1, , TRUE, 0);
    Close();
    ChangeGroupState('s_investigate');
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveTo,9,,,,'KitdUpPathC',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Patrol,8,,,,'KitdUpPathC',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(0.5);
    ResetGoals(3);
    Goal_Set(3,GOAL_MoveTo,9,,,,'KitdDownPathC',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(3,GOAL_Patrol,8,,,,'KitdDownPathC',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(1);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'SeeBobrov',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,8,,,,'SeeBobrov',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
TelHellsKitchen:
    Log("TelHellsKitchen");
    CheckIfIsUnconscious(1,'TelHellsKitchenB');
    Teleport(1, 'TelNodeK');
    KillNPC(1, FALSE, FALSE);
TelHellsKitchenB:
    Log("TelHellsKitchenB");
    CheckIfIsUnconscious(2,'TelHellsKitchenC');
    Teleport(2, 'TelNodeL');
    KillNPC(2, FALSE, FALSE);
TelHellsKitchenC:
    Log("TelHellsKitchenC");
    CheckIfIsUnconscious(3,'End');
    Teleport(3, 'TelNodeM');
    KillNPC(3, FALSE, FALSE);
End:
    End();

}

defaultproperties
{
}

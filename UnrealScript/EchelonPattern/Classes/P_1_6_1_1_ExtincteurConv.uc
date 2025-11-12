//=============================================================================
// P_1_6_1_1_ExtincteurConv
//=============================================================================
class P_1_6_1_1_ExtincteurConv extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_4_2Voice.uax

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
        if (P.name == 'spetsnaz1')
            Characters[1] = P.controller;
        if (P.name == 'spetsnaz0')
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
MilestoneExtincteurConv:
    Log("MilestoneExtincteurConv");
    Sleep(7);
    Goal_Set(1,GOAL_Action,9,,,,,'TalkStNmCC0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_40_01', 1, , TRUE, 0);
    Goal_Set(2,GOAL_Action,9,,,,,'LstnStNmCC0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_40_02', 2, , TRUE, 0);
    Goal_Set(2,GOAL_MoveTo,9,,,,'ConvAlekA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,8,,,,'ConvWalkA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,7,,'focuswalkconv','focuswalkconv','ConvWalkA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S3_4_2Voice.Play_34_40_03', 1, , TRUE, 0);
    Goal_Set(1,GOAL_MoveTo,9,,,,'AlekTelInMap',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,8,,'focuswalkconv','focuswalkconv','AlekTelInMap',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S3_4_2Voice.Play_34_40_04', 2, , TRUE, 0);
    Talk(Sound'S3_4_2Voice.Play_34_40_05', 1, , TRUE, 0);
    Talk(Sound'S3_4_2Voice.Play_34_40_06', 2, , TRUE, 0);
    Talk(Sound'S3_4_2Voice.Play_34_40_07', 1, , TRUE, 0);
    Talk(Sound'S3_4_2Voice.Play_34_40_08', 2, , TRUE, 0);
    Talk(Sound'S3_4_2Voice.Play_34_40_09', 1, , TRUE, 0);
    JumpRandom('AfterConvA', 0.33, 'AfterConvB', 0.67, 'AfterConvC', 1.00, , , ,); 
    End();
AfterConvA:
    Log("AfterConvA");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'EasierAvoidExA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,8,,,,'EasierAvoidExA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveTo,9,,,,'ExtPatD',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Patrol,8,,,,'ExtPatD',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
AfterConvB:
    Log("AfterConvB");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'ConvWalkA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,8,,,,'ConvWalkA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveTo,9,,,,'ExtPatD',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Patrol,8,,,,'ExtPatD',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
AfterConvC:
    Log("AfterConvC");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'EasierAvoidExA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,8,,,,'EasierAvoidExA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveTo,9,,,,'Closet',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,8,,'closetfocus','closetfocus','Closet',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
Tel:
    Log("Tel");
    CheckIfIsUnconscious(1,'TelB');
    Teleport(1, 'ExtincteurTelB');
    KillNPC(1, FALSE, TRUE);
TelB:
    Log("TelB");
    CheckIfIsUnconscious(2,'End');
    Teleport(2, 'ExtincteurTelA');
    KillNPC(2, FALSE, TRUE);
End:
    End();

}

defaultproperties
{
}

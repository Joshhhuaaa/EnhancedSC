//=============================================================================
// P_1_6_1_1_RadioFirst
//=============================================================================
class P_1_6_1_1_RadioFirst extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_4_2Voice.uax

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
        if(P.name == 'spetsnaz2')
            Characters[1] = P.controller;
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
MilestoneRadioFirst:
    Log("MilestoneRadioFirst");
    Sleep(4);
    JumpRandom('RadioSlow', 0.50, 'RadioFast', 1.00, , , , , , ); 
    End();
RadioSlow:
    Log("RadioSlow");
    Goal_Set(1,GOAL_MoveTo,9,,,,'PAfirstguyD',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,8,,,,'PAfirstguyD',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    Sleep(1.5);
RadioFast:
    Log("RadioFast");
    Goal_Set(1,GOAL_Wait,9,,,,,'RdioStNmNt0',FALSE,,,,);
    Talk(Sound'S3_4_2Voice.Play_34_20_01', 1, , TRUE, 0);
    JumpRandom('PostTalkA', 0.30, 'PostTalkB', 0.60, 'PostTalkC', 1.00, , , , ); 
    End();
PostTalkA:
    Log("PostTalkA");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PAfirstguyD',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,8,,,,'PAfirstguyD',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
PostTalkB:
    Log("PostTalkB");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'LastNodeA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,8,,,,'LastNodeA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
PostTalkC:
    Log("PostTalkC");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PAfirstguyA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,8,,,,'PAfirstguyA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
Tel:
    Log("Tel");
    CheckIfIsUnconscious(1,'End');
    Teleport(1, 'RadioOut');
    KillNPC(1, FALSE, TRUE);
End:
    End();

}

defaultproperties
{
}

//=============================================================================
// P_2_2_3_Ktech_RoofAmbushD
//=============================================================================
class P_2_2_3_Ktech_RoofAmbushD extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_2_3Voice.uax

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
        if(P.name == 'EMafiaMuscle11')
            Characters[1] = P.controller;
        if(P.name == 'EMafiaMuscle13')
            Characters[2] = P.controller;
        if(P.name == 'EMafiaMuscle12')
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
RoofAmbushD:
    Log("");
    Talk(Sound'S2_2_3Voice.Play_22_57_01', 1, , TRUE, 0);
    Talk(Sound'S2_2_3Voice.Play_22_57_02', 2, , TRUE, 0);
    Talk(Sound'S2_2_3Voice.Play_22_57_03', 1, , TRUE, 0);
    Talk(Sound'S2_2_3Voice.Play_22_57_04', 2, , TRUE, 0);
    Goal_Set(1,GOAL_MoveTo,9,,,,'RoofAmbushDNode01',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_MoveTo,8,,,,'RoofAmbushDNode03',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S2_2_3Voice.Play_22_57_05', 1, , TRUE, 0);
    Talk(Sound'S2_2_3Voice.Play_22_57_06', 2, , TRUE, 0);
    Talk(Sound'S2_2_3Voice.Play_22_57_07', 1, , TRUE, 0);
    Close();
    UpdateGoal(1,'RoofAmbushDNode01',FALSE,MOVE_WalkNormal);
    UpdateGoal(2,'RoofAmbushDNode05',FALSE,MOVE_JogAlert);
    UpdateGoal(3,'RoofAmbushDNode04',FALSE,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveTo,);
    WaitForGoal(1,GOAL_MoveTo,);
    UpdateGoal(1,'RoofAmbushDNode03',FALSE,MOVE_WalkNormal);
    UpdateGoal(1,'RoofAmbushDNode07',FALSE,MOVE_WalkNormal);
    UpdateGoal(2,'RoofAmbushDNode09',FALSE,MOVE_WalkNormal);
    UpdateGoal(3,'RoofAmbushDNode08',FALSE,MOVE_WalkNormal);
    End();
AISeePlayer:
    Log("");
    Close();
    SetExclusivity(FALSE);
    End();

}


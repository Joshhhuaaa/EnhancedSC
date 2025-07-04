//=============================================================================
// P_2_2_3_Ktech_RoofAmbushA
//=============================================================================
class P_2_2_3_Ktech_RoofAmbushA extends EPattern;

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
        if(P.name == 'EMafiaMuscle2')
            Characters[1] = P.controller;
        if(P.name == 'EMafiaMuscle0')
            Characters[2] = P.controller;
        if(P.name == 'EMafiaMuscle1')
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
KtechRoofGroup1:
    Log("Talk Over A Barrel");
    Goal_Set(1,GOAL_MoveTo,9,,,,'SEvent2Path01',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Guard,8,,,,'SEvent2Path01',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_MoveTo,);
    Talk(Sound'S2_2_3Voice.Play_22_56_01', 1, , TRUE, 0);
    Talk(Sound'S2_2_3Voice.Play_22_56_02', 2, , TRUE, 0);
    Talk(Sound'S2_2_3Voice.Play_22_56_03', 1, , TRUE, 0);
    Talk(Sound'S2_2_3Voice.Play_22_56_04', 3, , TRUE, 0);
    Talk(Sound'S2_2_3Voice.Play_22_56_05', 1, , TRUE, 0);
    Talk(Sound'S2_2_3Voice.Play_22_56_06', 2, , TRUE, 0);
    Talk(Sound'S2_2_3Voice.Play_22_56_07', 1, , TRUE, 0);
    Talk(Sound'S2_2_3Voice.Play_22_56_08', 3, , TRUE, 0);
    Talk(Sound'S2_2_3Voice.Play_22_56_09', 1, , TRUE, 0);
    Talk(Sound'S2_2_3Voice.Play_22_56_10', 2, , TRUE, 0);
    Talk(Sound'S2_2_3Voice.Play_22_56_11', 1, , TRUE, 0);
    Close();
    End();

}


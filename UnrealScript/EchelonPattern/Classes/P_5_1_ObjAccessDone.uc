//=============================================================================
// P_5_1_ObjAccessDone
//=============================================================================
class P_5_1_ObjAccessDone extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S5_1_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Triggered;


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
        if(P.name == 'EGeorgianPalaceGuard9')
            Characters[1] = P.controller;
        if(P.name == 'EGeorgianPalaceGuard10')
            Characters[2] = P.controller;
        if(P.name == 'EEliteForceCristavi8')
        {
            Characters[3] = P.controller;
            EAIController(Characters[3]).bAllowKnockout = true;
        }
        if(P.name == 'EEliteForceCristavi7')
            Characters[4] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    Triggered=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Milestone:
    Log("Milestone");
    CheckFlags(Triggered,TRUE,'End');
    SetFlags(Triggered,TRUE);
    Sleep(6);
    Talk(Sound'S5_1_1Voice.Play_51_15_01', 1, , TRUE, 0);
    Talk(Sound'S5_1_1Voice.Play_51_15_02', 2, , TRUE, 0);
    Talk(Sound'S5_1_1Voice.Play_51_15_03', 1, , TRUE, 0);
    Talk(Sound'S5_1_1Voice.Play_51_15_04', 2, , TRUE, 0);
    Talk(Sound'S5_1_1Voice.Play_51_15_05', 1, , TRUE, 0);
    Talk(Sound'S5_1_1Voice.Play_51_15_06', 2, , TRUE, 0);
    Talk(Sound'S5_1_1Voice.Play_51_15_07', 1, , TRUE, 0);
    Talk(Sound'S5_1_1Voice.Play_51_15_08', 2, , TRUE, 0);
    Talk(Sound'S5_1_1Voice.Play_51_15_09', 1, , TRUE, 0);
    Close();
    End();
PatrolNow:
    Log("PatrolNow");
    Sleep(1);
    Goal_Set(3,GOAL_MoveTo,9,,,,'lounge3_200',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(3,GOAL_Patrol,8,,,,'lounge3_200',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(4,GOAL_MoveTo,9,,,,'lounge2_400',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(4,GOAL_Patrol,8,,,,'lounge2_400',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
End:
    End();

}


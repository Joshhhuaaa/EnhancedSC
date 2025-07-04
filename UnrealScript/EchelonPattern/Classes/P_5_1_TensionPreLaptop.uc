//=============================================================================
// P_5_1_TensionPreLaptop
//=============================================================================
class P_5_1_TensionPreLaptop extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S5_1_1Voice.uax

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
        if(P.name == 'EGeorgianPalaceGuard21')
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
Milestone:
    Log("Milestone");
    Goal_Default(1,GOAL_Guard,1,,'LookOutsideMeka','LookOutsideMeka','AfterSearchOffOne',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,9,,,,'LookcrisPointCrisPointa',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,8,,'ELaptopCriz','ELaptopCriz','LookcrisPointCrisPointa',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S5_1_1Voice.Play_51_25_01', 1, , TRUE, 0);
    Close();
    Sleep(3);
    ResetGroupGoals();
    Goal_Set(1,GOAL_InteractWith,9,,,,'CrisL',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,8,,,,'LookcrisPointCrisPointa',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,7,,'ELaptopCriz','ELaptopCriz','LookcrisPointCrisPointa',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(9);
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveTo,9,,,,'AfterSearchOffOne',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,8,,'LookOutsideMeka','LookOutsideMeka','AfterSearchOffOne',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();

}


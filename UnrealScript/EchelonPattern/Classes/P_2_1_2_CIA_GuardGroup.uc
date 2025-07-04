//=============================================================================
// P_2_1_2_CIA_GuardGroup
//=============================================================================
class P_2_1_2_CIA_GuardGroup extends EPattern;

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
        if(P.name == 'ECIASecurity3')
            Characters[1] = P.controller;
        if(P.name == 'ECIASecurity2')
            Characters[2] = P.controller;
        if(P.name == 'ECIABureaucrat45')
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
Start:
    Log("");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode79',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Wait,7,,'StaticMeshActor444',,'Echair0','WaitChNmFdB',FALSE,,MOVE_WalkNormal,,MOVE_Sit);
    End();
FromEarlyFudge:
    Log("FromEarlyFudge");
    ResetGroupGoals();
    ChangeGroupState('s_alert');
    Goal_Set(1,GOAL_MoveTo,9,,,,'officewait',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Patrol,8,,,,'officewait',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(2,GOAL_MoveTo,9,,,,'Femalewait',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(2,GOAL_Guard,8,,'PathNode79Fok','PLAYER','Femalewait',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(3,GOAL_MoveTo,9,,,,'PN69',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Guard,8,,,,'PN69',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Sleep(6);
    ePawn(Characters[1].Pawn).Bark_Type = BARK_LookingForYou;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    End();

}


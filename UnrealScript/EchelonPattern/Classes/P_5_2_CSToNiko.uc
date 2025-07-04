//=============================================================================
// P_5_2_CSToNiko
//=============================================================================
class P_5_2_CSToNiko extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Done;


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
        if(P.name == 'EEliteForceCristavi6')
            Characters[1] = P.controller;
        if(P.name == 'ENikoladze0')
            Characters[2] = P.controller;
        if(P.name == 'EEliteForceCristavi5')
            Characters[3] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    Done=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Milestone:
    Log("Milestone");
    CheckFlags(V5_1_2_PresidentialPalace(Level.VarObject).ArkObtained,FALSE,'End');
    CheckFlags(Done,TRUE,'End');
    SetFlags(Done,TRUE);
    DisableMessages(TRUE, TRUE);
    Goal_Set(1,GOAL_MoveTo,9,,,,'CSNodeOne',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Guard,8,,,,'CSNodeOne',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(2,GOAL_MoveTo,9,,,,'CSNodeThree',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,8,,,,'CSNodeThree',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_MoveTo,9,,,,'CSNodeTwo',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(3,GOAL_Guard,8,,,,'CSNodeTwo',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    CinCamera(0, 'CameraAOneP', 'CameraAOneF',);
    Sleep(9);
    CinCamera(1, , ,);
    WaitForGoal(3,GOAL_MoveTo,);
    Teleport(1, 'TelPoint2');
    Teleport(2, 'NikoFakedDeath');
    Teleport(3, 'TelPointOne');
End:
    End();

}


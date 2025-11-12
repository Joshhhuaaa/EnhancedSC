//=============================================================================
// P_2_1_1CIA_Walkby1
//=============================================================================
class P_2_1_1CIA_Walkby1 extends EPattern;

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
        if (P.name == 'ECIABureaucrat13')
            Characters[1] = P.controller;
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
startwalkby1:
    Log("NPC walks in front of Sam");
    UpdateGoal(1,'PWalkby1',FALSE,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,9,,'EFocusPoint51',,'PathNode285',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,8,,'EFocusPoint51','EFocusPoint51','PathNode285',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();

}


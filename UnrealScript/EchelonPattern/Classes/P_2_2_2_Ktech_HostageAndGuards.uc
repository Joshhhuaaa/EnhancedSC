//=============================================================================
// P_2_2_2_Ktech_HostageAndGuards
//=============================================================================
class P_2_2_2_Ktech_HostageAndGuards extends EPattern;

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
        if (P.name == 'EMafiaMuscle12')
            Characters[1] = P.controller;
        if (P.name == 'EMafiaMuscle11')
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
HostageGuards:
    Log("Hostage Guards");
    Sleep(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'HostageGuardPostNode01',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_MoveTo,9,,,,'HostageGuardPostNode02',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Guard,8,,'HostageAndGuardsFocus01',,'HostageGuardPostNode01',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(2,GOAL_Guard,8,,'HostageAndGuardsFocus01',,'HostageGuardPostNode02',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();

}


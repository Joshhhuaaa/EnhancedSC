//=============================================================================
// P_3_4_2_Sev_Reinforcements
//=============================================================================
class P_3_4_2_Sev_Reinforcements extends EPattern;

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
        if (P.name == 'spetsnaz15')
            Characters[1] = P.controller;
        if (P.name == 'spetsnaz14')
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
Reinforcements:
    Log("A couple of Spetsnaz move from the building into the South Area of the Foundry room.");
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveTo,9,,'EremeiPattern10','PLAYER','EremeiPattern10',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(2,GOAL_MoveTo,9,,'EremeiPattern10','PLAYER','EpifanPattern10',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(1,GOAL_Guard,1,,'EpifanPattern10','PLAYER','EremeiPattern10',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(2,GOAL_Guard,1,,'EremeiPattern10','PLAYER','EpifanPattern10',,FALSE,,MOVE_WalkAlert,,MOVE_JogAlert);
    Sleep(6);
    ResetGroupGoals();
    Goal_Default(1,GOAL_Patrol,0,,,'PLAYER','Eremei_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkAlert);
    Goal_Default(2,GOAL_Patrol,0,,,'PLAYER','Epifan_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();

}

defaultproperties
{
}

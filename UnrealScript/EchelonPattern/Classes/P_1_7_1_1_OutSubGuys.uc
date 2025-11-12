//=============================================================================
// P_1_7_1_1_OutSubGuys
//=============================================================================
class P_1_7_1_1_OutSubGuys extends EPattern;

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
        if (P.name == 'spetsnaz4')
            Characters[1] = P.controller;
        if (P.name == 'spetsnaz5')
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
MilestoneOutSubGuys:
    Log("MilestoneOutSubGuys");
    ToggleGroupAI(TRUE, 'OutSubGuys', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    Goal_Set(1,GOAL_MoveTo,9,,,,'PostPissPathB',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Guard,8,,'stairwellbottomdoor','stairwellbottomdoor','PostPissPathB',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,9,,,,'PostPissPathC',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(2,GOAL_Guard,8,,'stairwellbottomdoor','stairwellbottomdoor','PostPissPathC',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();

}

defaultproperties
{
}

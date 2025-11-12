//=============================================================================
// P_1_2_1DefMin_GoalSouthDone
//=============================================================================
class P_1_2_1DefMin_GoalSouthDone extends EPattern;

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

    if (!bInit)
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Milestone:
    Log("MilestoneGoalSouthDone");
    SendPatternEvent('UselessG','SpiterStart');
    GoalCompleted('1_2_3');
    End();

}


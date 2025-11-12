//=============================================================================
// P_1_2_1DefMin_GoalOneDone
//=============================================================================
class P_1_2_1DefMin_GoalOneDone extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Done;


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
    Done=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Milestone:
    Log("MilestoneGoalOneDone");
    CheckFlags(Done,TRUE,'End');
    SetFlags(Done,TRUE);
    SetFlags(V1_2_1DefenseMinistry(Level.VarObject).WestWingFastDone,TRUE);
    SendPatternEvent('FirstNPC','Milestone');
    GoalCompleted('1_2_1');
End:
    End();

}


//=============================================================================
// P_4_1_1_CEmb_ZetsGoToNextLevel
//=============================================================================
class P_4_1_1_CEmb_ZetsGoToNextLevel extends EPattern;

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
    Log("Milestone");
    Sleep(1);
    CheckFlags(V4_1_1ChineseEmbassy(Level.VarObject).GoalAgencyContact,FALSE,'DoNothing');
    LevelChange("4_1_2ChineseEmbassy");
    End();
DoNothing:
    Log("Doing nothing");
    End();

}


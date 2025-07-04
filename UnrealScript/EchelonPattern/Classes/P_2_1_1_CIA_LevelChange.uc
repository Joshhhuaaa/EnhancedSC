//=============================================================================
// P_2_1_1_CIA_LevelChange
//=============================================================================
class P_2_1_1_CIA_LevelChange extends EPattern;

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

    if( !bInit )
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Part2:
    Log("The wheels on the bus go round and round");
    LevelChange("2_1_2CIA");
End:
    End();

}


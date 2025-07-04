//=============================================================================
// P_0_0_2_Training_Description
//=============================================================================
class P_0_0_2_Training_Description extends EPattern;

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

    SetPatternAlwaysTick();
}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
LatentDesc:
    Log("This label is only running a latent function on the 002 Training Desc pattern");
    SetFlags(V0_0_2_Training(Level.VarObject).BoxTipPlayed,TRUE);
    AddTrainingData(Localize("P_0_0_2_Training_Description", "Training_0013L", "Localization\\P_0_0_2_Training"), KEY_NONE_MASK | KEY_INTERACTION_MASK, FALSE);
    End();

}


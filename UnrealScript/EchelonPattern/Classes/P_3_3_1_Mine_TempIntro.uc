//=============================================================================
// P_3_3_1_Mine_TempIntro
//=============================================================================
class P_3_3_1_Mine_TempIntro extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('DeadETC');
            break;
        case AI_UNCONSCIOUS:
            EventJump('DeadETC');
            break;
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
DeadETC:
    Log("DeadETC");
    SetProfileDeletion();
    Speech(Localize("P_3_3_1_Mine_TempIntro", "Speech_0001L", "Localization\\P_3_3_1MiningTown"), None, 3, 0, TR_HEADQUARTER, 0, false);
    Sleep(3);
    Close();
    GameOver(false, 0);
    End();

}

defaultproperties
{
}

//=============================================================================
// P_1_2_1DefMin_ZoNextLeavel
//=============================================================================
class P_1_2_1DefMin_ZoNextLeavel extends EPattern;

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
Milestone:
    Log("Milestone");
    SetFlags(V1_2_1DefenseMinistry(Level.VarObject).TooFastLaserMic,TRUE);
    CheckFlags(V1_2_1DefenseMinistry(Level.VarObject).LaserMicDone,FALSE,'TooSoonToLevChange');
    LevelChange("1_2_2DefenseMinistry");
    End();
TooSoonToLevChange:
    Log("TooSoonToLevChange");
    SendPatternEvent('GrinkoMasse','JumpHereLaserMicFuck');
    End();

}


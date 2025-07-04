//=============================================================================
// P_4_2_1_Abt_RoofBackMain
//=============================================================================
class P_4_2_1_Abt_RoofBackMain extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int pass1;


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
    pass1=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
RoofNoise:
    Log("");
    CheckFlags(pass1,TRUE,'JumpFin');
jump1:
    SendPatternEvent('EGroupAI1','RoofNoise');
    SetFlags(pass1,TRUE);
    End();
ResetPass1:
    Log("");
    SetFlags(pass1,FALSE);
    End();
AlarmINstudio:
    Log("");
    SendPatternEvent('EGroupAI1','AlarmINstudio');
    End();
JumpFin:
    Log("");
    End();
GrinkoTalk:
    Log("");
    SendPatternEvent('EGroupAI1','GrinkoTalk');
    End();
StopTalk:
    Log("");
    CheckFlags(pass1,TRUE,'JumpFin');
    SendPatternEvent('EGroupAI1','StopTalk');
    End();

}


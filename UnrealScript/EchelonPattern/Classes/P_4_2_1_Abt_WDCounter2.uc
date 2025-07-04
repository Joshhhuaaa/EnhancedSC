//=============================================================================
// P_4_2_1_Abt_WDCounter2
//=============================================================================
class P_4_2_1_Abt_WDCounter2 extends EPattern;

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
Start:
    Log("");
    CheckFlags(pass1,TRUE,'NoSpeach');
    SetFlags(pass1,TRUE);
    End();
NoSpeach:
    Log("");
    SendPatternEvent('EGroupAI30','JumpFin');
    SendPatternEvent('ggCourt1','JustCine');
    End();

}


//=============================================================================
// P_4_2_2_Abt_SpawnOrder
//=============================================================================
class P_4_2_2_Abt_SpawnOrder extends EPattern;

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
    Sleep(4);
    Log("Spawn the colonel");
    SendPatternEvent('EGroupAI12','SpawnC');
    SendPatternEvent('EGroupAI19','SpawnC');
    Sleep(1);
    Log("Spawn Grinko");
    SendPatternEvent('EGroupAI21','SpawnG');
    SetFlags(pass1,TRUE);
    End();
ColonelToDefault:
    Log("");
    CheckFlags(pass1,FALSE,'JumpFin');
    SendPatternEvent('EGroupAI12','GetToDefaut');
    SendPatternEvent('EGroupAI19','GetToDefaut');
JumpFin:
    Log("");
    End();
GrinkoStart:
    Log("");
    CheckFlags(pass1,FALSE,'JumpFin');
    SendPatternEvent('EGroupAI21','Main');
    End();

}


//=============================================================================
// P_1_1_2_Tbilisi_PrisonKiller
//=============================================================================
class P_1_1_2_Tbilisi_PrisonKiller extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int MemOneKilled;
var int MemTwoKilled;


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

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'EAINonHostile0')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    MemOneKilled=0;
    MemTwoKilled=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
    Log("This pattern is ticking to see if Sam is killing the prisoners.");
NotifyLambert:
    Log("Sam has killed a civilian, sending info to lambert pattern");
    SendPatternEvent('LambertAI','Murder');
    Log("a jump to lable Checking was here and has been removed because I think its unnecessary as there is onyl one prisoner. If this causes bugs, put the jump back in.");
    End();
DoNothing:
    Log("Doing Nothing");
    End();
Checking:
    Log("demo checking every two seconds");
    Sleep(2);
    CheckIfIsDead(1,'M1Dead');
    Jump('Checking');
    End();
M1Dead:
    Log("member one snuffed");
    CheckFlags(MemOneKilled,TRUE,'DoNothing');
    SetFlags(MemOneKilled,TRUE);
    Jump('NotifyLambert');
    End();

}


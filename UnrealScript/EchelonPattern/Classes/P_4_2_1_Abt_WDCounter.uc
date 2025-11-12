//=============================================================================
// P_4_2_1_Abt_WDCounter
//=============================================================================
class P_4_2_1_Abt_WDCounter extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int DeathCount1;
var int U1dead;
var int U2dead;
var int U3dead;


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
        if (P.name == 'EGeorgianSoldier5')
            Characters[1] = P.controller;
        if (P.name == 'EGeorgianSoldier6')
            Characters[2] = P.controller;
        if (P.name == 'EGeorgianSoldier7')
            Characters[3] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    DeathCount1=0;
    U1dead=0;
    U2dead=0;
    U3dead=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Start:
    Log("");
U1chek:
    CheckIfIsDead(1,'Unit1Dead');
    CheckIfIsUnconscious(1,'Unit1Dead');
U2chek:
    CheckIfIsDead(2,'Unit2Dead');
    CheckIfIsUnconscious(2,'Unit2Dead');
U3chek:
    CheckIfIsDead(3,'Unit3Dead');
    CheckIfIsUnconscious(3,'Unit3Dead');
EndPart1:
    Log("");
Send1:
    Log("");
    CheckFlags(U1dead,FALSE,'Send2');
    SendPatternEvent('EGroupAI31','Start');
    Sleep(0.6);
Send2:
    Log("");
    CheckFlags(U2dead,FALSE,'Send3');
    SendPatternEvent('EGroupAI31','Start');
    Sleep(0.6);
Send3:
    Log("");
    CheckFlags(U3dead,FALSE,'EndPart2');
    SendPatternEvent('EGroupAI31','Start');
    Sleep(0.6);
EndPart2:
    Log("");
    SendPatternEvent('ggCourt1','Speach');
    End();
Unit1Dead:
    Log("");
    SetFlags(U1dead,TRUE);
    Jump('U2chek');
Unit2Dead:
    Log("");
    SetFlags(U2dead,TRUE);
    Jump('U3chek');
Unit3Dead:
    Log("");
    SetFlags(U3dead,TRUE);
    Jump('EndPart1');
JumpFin:
    Log("");
    End();

}


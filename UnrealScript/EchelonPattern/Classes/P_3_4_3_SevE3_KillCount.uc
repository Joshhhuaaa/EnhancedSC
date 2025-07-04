//=============================================================================
// P_3_4_3_SevE3_KillCount
//=============================================================================
class P_3_4_3_SevE3_KillCount extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int OneAlive;
var int TwoAlive;


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

    ForEach DynamicActors(class'Pawn', P)
    {
        if(P.name == 'spetsnaz16')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
            EAIController(Characters[1]).bBlockDetection = true;
            EAIController(Characters[1]).bWasFound = true;
        }
        if(P.name == 'spetsnaz19')
        {
            Characters[2] = P.controller;
            EAIController(Characters[2]).bAllowKnockout = true;
            EAIController(Characters[2]).bBlockDetection = true;
            EAIController(Characters[2]).bWasFound = true;
        }
    }

    if( !bInit )
    {
    bInit=TRUE;
    OneAlive=1;
    TwoAlive=1;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
    Log("This pattern checks as the guys in the ballroom are killed. THIS PATTERN IS NOT EXCLUSIVE TO E3. DO NOT DELETE");
Checking:
    Log("Checking members every second");
    Sleep(1);
    CheckIfIsDead(1,'ONE');
    CheckIfIsUnconscious(1,'ONE');
CheckTwo:
    CheckIfIsUnconscious(2,'TWO');
    CheckIfIsDead(2,'TWO');
    Jump('Checking');
ONE:
    Log("Member One is Done");
    SetFlags(OneAlive,FALSE);
    CheckFlags(TwoAlive,FALSE,'Finito');
    Jump('CheckTwo');
TWO:
    Log("Member Two is Done");
    SetFlags(TwoAlive,FALSE);
    CheckFlags(OneAlive,FALSE,'Finito');
    Jump('Checking');
Finito:
    Log("All are dealt with, going to other pattern");
    SendPatternEvent('TerraHaute','AttackEnds');
    End();

}

defaultproperties
{
}

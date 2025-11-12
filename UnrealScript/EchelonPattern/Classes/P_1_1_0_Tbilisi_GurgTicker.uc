//=============================================================================
// P_1_1_0_Tbilisi_GurgTicker
//=============================================================================
class P_1_1_0_Tbilisi_GurgTicker extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int DeathPlayed;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('GurgDead');
            break;
        case AI_UNCONSCIOUS:
            EventJump('GurgDead');
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

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'EBaxter0')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    DeathPlayed=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
    Log("This pattern is solely keeping track of whether or not Gurgenidze dying is okay");
GurgDead:
    Log("gurgenidze is dead");
    CheckFlags(V1_1_0Tbilisi(Level.VarObject).GurgCanDie,TRUE,'NextStep');
    SetExclusivity(TRUE);
    DisableMessages(TRUE, TRUE);
    SendPatternEvent('LambertAI','StrikeTwo');
    End();
NextStep:
    Log("Going to Lambert Pattern to tell Sam what to do next");
    SendPatternEvent('LambertAI','ContactDies');
    End();
DoNothing:
    Log("Doing Nothing");
    End();

}


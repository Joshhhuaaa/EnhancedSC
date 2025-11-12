//=============================================================================
// P_1_3_3OilRig_DannyCarey
//=============================================================================
class P_1_3_3OilRig_DannyCarey extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int EscortClear;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_GRABBED:
            EventJump('Exclu');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('Exclu');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('Exclu');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('Exclu');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Exclu');
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
        if (P.name == 'EGeorgianSoldier16')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    EscortClear=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Lateralus:
    Log("Push the envelope, watch it bend.");
    SetExclusivity(FALSE);
    Goal_Default(1,GOAL_Patrol,2,,,,'Danny_0',,FALSE,,,,);
    End();
JerkOff:
    Log("If consequences dictate our course of action, and it doesn't matter what's right, it's only wrong if you get caught.  If consequences dictate my course of action I should...");
    SetFlags(EscortClear,TRUE);
    KillNPC(1, FALSE, FALSE);
    End();
Exclu:
    Log("Resets Danny Carey exclusivity EARLY.");
    SetExclusivity(FALSE);
    CheckFlags(EscortClear,FALSE,'Divorced');
    End();
EscortClear:
    Log("The escort is clear of Danny, he is game.");
    SetFlags(EscortClear,TRUE);
    End();
Jets:
    Log("Danny is the final jet monkey.");
    Goal_Set(1,GOAL_Stop,9,,,,,,FALSE,7.5,,,);
    End();
Divorced:
    Log("She's got a voice like a fucking modem, man..  BRREEEIEAASEEMEEMOOSIK?");
    SendPatternEvent('JedediahAI','GameOverMan');
    End();

}


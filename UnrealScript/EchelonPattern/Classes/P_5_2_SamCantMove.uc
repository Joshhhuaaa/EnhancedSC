//=============================================================================
// P_5_2_SamCantMove
//=============================================================================
class P_5_2_SamCantMove extends EPattern;

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

    ForEach DynamicActors(class'Pawn', P)
    {
        if(P.name == 'EEliteForceCristavi14')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
            EAIController(Characters[1]).bBlockDetection = true;
            EAIController(Characters[1]).bWasFound = true;
        }
    }

    if( !bInit )
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Cycle:
    Log("Cycle");
    Sleep(0.50);
    CheckPlayerPlan('DeathMove');
    Jump('Cycle');
    End();
DeathMove:
    Log("DeathMove");
    CheckFlags(V5_1_2_PresidentialPalace(Level.VarObject).NowSurrounded,FALSE,'End');
    CheckFlags(V5_1_2_PresidentialPalace(Level.VarObject).DarknessVault,TRUE,'End');
    SendPatternEvent('Nikoo','KillNikoAndPlayerBecauseMoved');
End:
    End();

}


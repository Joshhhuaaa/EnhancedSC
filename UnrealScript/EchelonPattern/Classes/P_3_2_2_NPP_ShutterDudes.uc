//=============================================================================
// P_3_2_2_NPP_ShutterDudes
//=============================================================================
class P_3_2_2_NPP_ShutterDudes extends EPattern;

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
        if(P.name == 'EFalseRussianSoldier2')
            Characters[1] = P.controller;
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
Froggie:
    Log("Ribbit ribbit.");
    SendPatternEvent('RelayRoomAITwo','Frogger');
    Goal_Set(1,GOAL_Wait,9,,,,,,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    End();
Anubis:
    Log("Summons the dark lord of the Nephilim.");
    SendPatternEvent('RelayRoomAITwo','Pezuzu');
    ResetGroupGoals();
    Goal_Set(1,GOAL_Attack,9,,'PLAYER','PLAYER',,,FALSE,,,,);
    Sleep(30);
    SetExclusivity(FALSE);
    End();

}

defaultproperties
{
}

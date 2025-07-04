//=============================================================================
// P_3_2_2_NPP_ShutterDudesDeux
//=============================================================================
class P_3_2_2_NPP_ShutterDudesDeux extends EPattern;

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
        if(P.name == 'EFalseRussianSoldier4')
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
Frogger:
    Log("Croak croak.");
    Goal_Set(1,GOAL_Wait,9,,,,,,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    End();
Pezuzu:
    Log("Summons the dark lord of the Pit of Desecration.");
    ResetGroupGoals();
    Goal_Set(1,GOAL_Attack,9,,'PLAYER','PLAYER',,,FALSE,,,,);
    Sleep(40);
    SetExclusivity(FALSE);
    End();

}

defaultproperties
{
}

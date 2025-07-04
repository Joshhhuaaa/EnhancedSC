//=============================================================================
// P_1_7_1_2_DormsTeam
//=============================================================================
class P_1_7_1_2_DormsTeam extends EPattern;

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
        if(P.name == 'spetsnaz10')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz9')
            Characters[2] = P.controller;
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
MilestoneDormsTeam:
    Log("MilestoneDormsTeam");
    Sleep(3);
    Goal_Set(1,GOAL_InteractWith,9,,'TDormsLSa','TDormsLSa','TDormsLSa',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
TelDormsTeam:
    Log("TelDormsTeam");
    CheckIfIsUnconscious(1,'TelBDormsTeam');
    Teleport(1, 'TelNodeM');
    KillNPC(1, FALSE, FALSE);
TelBDormsTeam:
    Log("TelBDormsTeam");
    CheckIfIsUnconscious(2,'End');
    Teleport(2, 'TelNodeN');
    KillNPC(2, FALSE, FALSE);
End:
    End();

}

defaultproperties
{
}

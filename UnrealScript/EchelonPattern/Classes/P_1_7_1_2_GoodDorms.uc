//=============================================================================
// P_1_7_1_2_GoodDorms
//=============================================================================
class P_1_7_1_2_GoodDorms extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



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
        if (P.name == 'spetsnaz18')
            Characters[1] = P.controller;
        if (P.name == 'EFalseRussianSoldier0')
            Characters[2] = P.controller;
        if (P.name == 'EFalseRussianSoldier2')
            Characters[3] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
MilestoneGoodDorms:
    Log("MilestoneGoodDorms");
    ToggleGroupAI(TRUE, 'GoodDorms', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    SetExclusivity(FALSE);
    Goal_Set(1,GOAL_MoveTo,9,,,,'GoodDormPatA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,8,,,,'GoodDormPatA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
TelGoodDorms:
    Log("TelGoodDorms");
    CheckIfIsUnconscious(1,'TelBGoodDorms');
    Teleport(1, 'TelNodeB');
    KillNPC(1, FALSE, FALSE);
TelBGoodDorms:
    Log("TelBGoodDorms");
    CheckIfIsUnconscious(2,'TelCGoodDorms');
    Teleport(2, 'TelNodeC');
    KillNPC(2, FALSE, FALSE);
TelCGoodDorms:
    Log("TelCGoodDorms");
    CheckIfIsUnconscious(3,'End');
    Teleport(3, 'TelNodeD');
    KillNPC(3, FALSE, FALSE);
End:
    End();

}

defaultproperties
{
}

//=============================================================================
// P_1_7_1_2_BottomThree
//=============================================================================
class P_1_7_1_2_BottomThree extends EPattern;

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
        if (P.name == 'EFalseRussianSoldier5')
            Characters[1] = P.controller;
        if (P.name == 'spetsnaz14')
            Characters[2] = P.controller;
        if (P.name == 'spetsnaz16')
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
MilestoneBottomThree:
    Log("MilestoneBottomThree");
    ToggleGroupAI(TRUE, 'BottomThree', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    SetExclusivity(FALSE);
    End();
TelBottomThree:
    Log("TelBottomThree");
    CheckIfIsUnconscious(1,'TelBBottomThree');
    Teleport(1, 'TelNodeR');
    KillNPC(1, FALSE, FALSE);
TelBBottomThree:
    Log("TelBBottomThree");
    CheckIfIsUnconscious(2,'TelCBottomThree');
    Teleport(2, 'TelNodeS');
    KillNPC(2, FALSE, FALSE);
TelCBottomThree:
    Log("TelCBottomThree");
    CheckIfIsUnconscious(3,'End');
    Teleport(3, 'TelNodeT');
    KillNPC(3, FALSE, FALSE);
End:
    End();

}

defaultproperties
{
}

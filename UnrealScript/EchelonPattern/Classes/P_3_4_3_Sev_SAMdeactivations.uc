//=============================================================================
// P_3_4_3_Sev_SAMdeactivations
//=============================================================================
class P_3_4_3_Sev_SAMdeactivations extends EPattern;

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
        if (P.name == 'ELambert0')
            Characters[1] = P.controller;
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
    Log("This pattern tracks the states of the three SAM units, and ultimately destroys them.");
aSAMisDown:
    Log("One of the three SAMs is switched off.");
    CheckFlags(V3_4_3Severonickel(Level.VarObject).AllSAMActive,TRUE,'FirstSAMDown');
    CheckFlags(V3_4_3Severonickel(Level.VarObject).TwoSAMActive,TRUE,'SecondSAMDown');
    CheckFlags(V3_4_3Severonickel(Level.VarObject).OneSAMActive,TRUE,'ThirdSAMDown');
    End();
FirstSAMDown:
    Log("The first of the SAMs in deactivated.");
    SetFlags(V3_4_3Severonickel(Level.VarObject).AllSAMActive,FALSE);
    SendPatternEvent('LambertAI','SAMA');
    End();
SecondSAMDown:
    Log("The second SAM is deactivated");
    SetFlags(V3_4_3Severonickel(Level.VarObject).TwoSAMActive,FALSE);
    SendPatternEvent('LambertAI','SAMB');
    End();
ThirdSAMDown:
    Log("The third SAM is deactivated.");
    SetFlags(V3_4_3Severonickel(Level.VarObject).OneSAMActive,FALSE);
    SendPatternEvent('LambertAI','SAMC');
    GoalCompleted('SAMS');
    End();

}

defaultproperties
{
}

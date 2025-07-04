//=============================================================================
// P_1_6_1_1_FlashPath
//=============================================================================
class P_1_6_1_1_FlashPath extends EPattern;

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
        if(P.name == 'spetsnaz12')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz11')
            Characters[2] = P.controller;
        if(P.name == 'EAleksee0')
        {
            Characters[3] = P.controller;
            EAIController(Characters[3]).bAllowKnockout = true;
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
MilestoneFlashPath:
    Log("MilestoneFlashPath");
    CheckFlags(V1_6_1_1KolaCell(Level.VarObject).ServerObj,FALSE,'End');
    CheckIfGrabbed(3,'TelThemIn');
    End();
TelThemIn:
    Log("TelThemIn");
    SendUnrealEvent('TriggersFlashers');
    Teleport(1, 'FlasherOneA');
    Teleport(2, 'PostForcedAttackBack');
    ResetGoals(1);
    ResetGoals(2);
    Goal_Default(1,GOAL_Patrol,9,,,,'FlasherOneA',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(2,GOAL_Patrol,9,,,,'PostForcedAttackBack',,FALSE,,MOVE_Search,,MOVE_Search);
    SetExclusivity(FALSE);
    End();
LightsOff:
    Log("LightsOff");
    CheckFlags(V1_6_1_1KolaCell(Level.VarObject).Lazerz,TRUE,'LazerzOffEnd');
    ToggleGroupAI(TRUE, 'Flashers', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    Goal_Set(1,GOAL_InteractWith,9,,,,'BasementLights',,FALSE,,,,);
    WaitForGoal(1,GOAL_InteractWith,);
    ToggleGroupAI(FALSE, 'Flashers', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    End();
LazerzOffEnd:
    Log("LazerzOffEnd");
    SendUnrealEvent('ImpossibleLazerz');
    SetFlags(V1_6_1_1KolaCell(Level.VarObject).Lazerz,TRUE);
    LockDoor('ambushbehinddoor', FALSE, TRUE);
    End();
Tel:
    Log("Tel");
    CheckIfIsUnconscious(1,'TelB');
    Teleport(1, 'FlashOverA');
    KillNPC(1, FALSE, TRUE);
TelB:
    Log("TelB");
    CheckIfIsUnconscious(2,'End');
    Teleport(2, 'FlashOverB');
    KillNPC(2, FALSE, TRUE);
End:
    End();

}

defaultproperties
{
}

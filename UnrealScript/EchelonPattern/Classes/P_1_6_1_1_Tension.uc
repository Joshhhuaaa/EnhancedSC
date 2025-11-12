//=============================================================================
// P_1_6_1_1_Tension
//=============================================================================
class P_1_6_1_1_Tension extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\Door.uax

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
    local Actor A;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'spetsnaz18')
            Characters[1] = P.controller;
        if (P.name == 'EAleksee0')
            Characters[2] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if (A.name == 'StaticMeshActor128')
            SoundActors[0] = A;
        if (A.name == 'StaticMeshActor919')
            SoundActors[1] = A;
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
MilestoneTension:
    Log("MilestoneTension");
    CheckIfGrabbed(2,'CarryOn');
    End();
CarryOn:
    Log("CarryOn");
    ToggleGroupAI(TRUE, 'LoneTense', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    JumpRandom('CarryOnA', 0.50, 'CarryOnB', 1.00, , , , , ,); 
    End();
CarryOnA:
    Log("CarryOnA");
	SoundActors[0].PlaySound(Sound'Door.Play_WoodDoorOpen', SLOT_SFX);
    Teleport(1, 'TensionGrabbing');
    Goal_Set(1,GOAL_MoveTo,9,,,,'ExtPatA',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Patrol,8,,,,'ExtPatA',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    SetExclusivity(FALSE);
    End();
CarryOnB:
    Log("CarryOnB");
	SoundActors[1].PlaySound(Sound'Door.Play_WoodDoorOpen', SLOT_SFX);
    Teleport(1, 'TensionRandomS');
    Goal_Set(1,GOAL_MoveTo,9,,,,'ExtPatA',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Patrol,8,,,,'ExtPatA',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    SetExclusivity(FALSE);
    End();
Tel:
    Log("Tel");
    CheckIfIsUnconscious(1,'End');
    Teleport(1, 'TelTensionOut');
    KillNPC(1, FALSE, TRUE);
End:
    End();

}

defaultproperties
{
}

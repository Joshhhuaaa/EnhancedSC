//=============================================================================
// P_1_6_1_1_BeforeLast
//=============================================================================
class P_1_6_1_1_BeforeLast extends EPattern;

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
        if (P.name == 'spetsnaz21')
            Characters[1] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if (A.name == 'StaticMeshActor167')
            SoundActors[0] = A;
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
MilestoneBeforeLast:
    Log("MilestoneBeforeLast");
    ToggleGroupAI(TRUE, 'BeforeLast', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    Sleep(0.50);
    Teleport(1, 'HereBetter');
    ResetGoals(1);
    ChangeState(1,'s_alert');
    Goal_Default(1,GOAL_Guard,9,,'BasePAttC','BasePAttC','HereBetter',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    SetExclusivity(FALSE);
    End();
BigDoorOutSound:
    Log("BigDoorOutSound");
    ToggleGroupAI(TRUE, 'GroupExtincteur', 'GroupLoneForSplit', 'Lockerz', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
	SoundActors[0].PlaySound(Sound'Door.Play_GlassDoorLaboratoryOpen', SLOT_SFX);
    End();

}

defaultproperties
{
}

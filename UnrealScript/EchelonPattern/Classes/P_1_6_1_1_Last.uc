//=============================================================================
// P_1_6_1_1_Last
//=============================================================================
class P_1_6_1_1_Last extends EPattern;

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
        if (P.name == 'spetsnaz20')
            Characters[1] = P.controller;
        if (P.name == 'spetsnaz17')
            Characters[2] = P.controller;
    }

    ForEach AllActors(class'Actor', A)
    {
        if (A.name == 'StaticMeshActor137')
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
MilestoneLast:
    Log("MilestoneLast");
    ToggleGroupAI(TRUE, 'Last', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    Sleep(0.50);
    Teleport(1, 'LastNodeA');
    Teleport(2, 'PAfirstguyA');
    ResetGoals(1);
    ResetGoals(2);
    ChangeGroupState('s_alert');
    Goal_Default(1,GOAL_Patrol,9,,,,'LastNodeA',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(2,GOAL_Patrol,9,,,,'PAfirstguyA',,FALSE,,MOVE_Search,,MOVE_Search);
    SetExclusivity(FALSE);
    End();
BigDoorInSound:
    Log("BigDoorInSound");
	SoundActors[0].PlaySound(Sound'Door.Play_GlassDoorLaboratoryOpen', SLOT_SFX);
    End();

}

defaultproperties
{
}

//=============================================================================
// P_3_2_1_NPP_MeltdownHalfway
//=============================================================================
class P_3_2_1_NPP_MeltdownHalfway extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_2_1Voice.uax

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
        if (P.name == 'EFalseRussianSoldier26')
            Characters[1] = P.controller;
        if (P.name == 'EFalseRussianSoldier27')
            Characters[2] = P.controller;
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
Half:
    Log("The cooling system is at 50%, send in 2 guards to investigate.");
    Jump('HoppityHop');
    Teleport(1, 'MeltHalf1');
    Teleport(2, 'MeltHalf2');
    Goal_Set(1,GOAL_MoveTo,9,,,,'midmidway',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(2,GOAL_MoveTo,9,,,,'Midway',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Patrol,8,,,,'Max_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(2,GOAL_Patrol,8,,,,'Sam_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    End();
HoppityHop:
    Speech(Localize("P_3_2_1_NPP_MeltdownHalfway", "Speech_0001L", "Localization\\P_3_2_1_PowerPlant"), Sound'S3_2_1Voice.Play_32_28_01', 1, 0, TR_NPCS, 0, false);
    Sleep(0.1);
    Close();
    End();

}

defaultproperties
{
}
